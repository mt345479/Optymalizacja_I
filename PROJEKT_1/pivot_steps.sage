#
# Rozne implementacje pivot rules
#

import numpy as np
from numpy import linalg as LA
import random

# Porzadek leksykograficzny, minimum

def lexicographical_min_entering(self):
	return min(self.possible_entering())

def lexicographical_min_leaving(self):
	return min(self.possible_leaving())

###############################################
# 0 #     leksykograficzny, maximum           #
###############################################

def lexicographical_max_entering(self):
	return max(self.possible_entering())

def lexicographical_max_leaving(self):
	return max(self.possible_leaving())

###############################################
# 1 #         LARGEST COEFFICIENT             #
###############################################

def largest_coefficient_entering(self):
    List = list(self.objective_coefficients())  # wektor współczynników funkcji celu
    Max = List.index(max(List))                 # indeks największego z nich
    return list(self.nonbasic_variables())[Max] # nazwa zmiennej (spoza bazy) o największym wsp. f-ji celu

def largest_coefficient_leaving(self):
    return self.possible_leaving()[0]           # zwracam tak naprawdę cokolwiek xD

###############################################
# 2 #          LARGEST INCREASE               #
###############################################

def largest_increase(self):
    Wart = self.objective_value()               # początkowa (obecna) wartość funkcji celu
    for Enter in self.possible_entering():      # szukam najlepszego wejścia
        P = deepcopy(self)                      # kopia problemu (bo z czymś trzeba porównywać)
        P.enter(Enter)
        for Leave in P.possible_leaving():      # szukam najlepszego wyjścia w obrębie danego wejścia
            R = deepcopy(P)                     # analogiczna kopia, jak przy badaniu wejścia
            R.leave(Leave)
            R.update()
            Wart_tmp = R.objective_value()      # sprawdzenie, czy zmiana bazy "pomogła"
            if Wart_tmp >= Wart:
                Wart = Wart_tmp                 # aktualizacja wartości funkcji celu
                ENTER = Enter
                LEAVE = Leave
    return ([ENTER, LEAVE])

def largest_increase_entering(self):
    return largest_increase(self)[0]

def largest_increase_leaving(self):
    return largest_increase(self)[1]

###############################################
# 3 #          SMALLEST INCREASE              #
###############################################

def smallest_increase(self):
    S = deepcopy(self)
    ENTER = S.possible_entering()[0]
    S.enter(ENTER)
    LEAVE = S.possible_leaving()[0]
    S.leave(LEAVE)
    S.update()
    Wart = S.objective_value()                  # początkowa (obecna) wartość funkcji celu
    
    for Enter in self.possible_entering():      # szukam najlepszego wejścia
        P = deepcopy(self)                      # kopia problemu (bo z czymś trzeba porównywać)
        P.enter(Enter)
        for Leave in P.possible_leaving():      # szukam najlepszego wyjścia w obrębie danego wejścia
            R = deepcopy(P)                     # analogiczna kopia, jak przy badaniu wejścia
            R.leave(Leave)
            R.update()
            Wart_tmp = R.objective_value()      # sprawdzenie, czy zmiana bazy "pomogła"
            if Wart_tmp <= Wart:
                Wart = Wart_tmp                 # aktualizacja wartości funkcji celu
                ENTER = Enter
                LEAVE = Leave
    return ([ENTER, LEAVE])

def smallest_increase_entering(self):
    return smallest_increase(self)[0]

def smallest_increase_leaving(self):
    return smallest_increase(self)[1]

###############################################
# 4 #            STEEPEST EDGE                #
###############################################

def steepest_edge(self):
    Kat = -1                                              # miara kąta między wektorem i gradientem
    S = deepcopy(self)
    ENTER = S.possible_entering()[0]
    S.enter(ENTER)
    LEAVE = S.possible_leaving()[0]
    S.leave(LEAVE)
    S.update()
    a = self.basic_solution()                             # punkt początkowy
    c = self.objective_coefficients()                     # c to grandient
    for Enter in self.possible_entering():
        C = deepcopy(self)
        C.enter(Enter)
        for Leave in C.possible_leaving():
            P = deepcopy(C)
            P.leave(Leave)
            P.update()
            b = P.basic_solution()
            d = b-a                                       # d to wektor w kierunku danego wierzchołka
            Kat_tmp = np.dot(c,d)/(LA.norm(d)*LA.norm(c)) # kąt jako iloraz iloczynu skalarnego oraz iloczynu norm
            if Kat_tmp > Kat:
                Kat = Kat_tmp
                ENTER = Enter
                LEAVE = Leave
    return ([ENTER, LEAVE])

def steepest_edge_entering(self):
    return steepest_edge(self)[0]

def steepest_edge_leaving(self):
    return steepest_edge(self)[1]

###############################################
# 5 #         MOST GRADUAL EDGE               #
###############################################

def gradual_edge(self):
    Kat = 1000                                            # miara kąta między wektorem i gradientem
    S = deepcopy(self)
    ENTER = S.possible_entering()[0]
    S.enter(ENTER)
    LEAVE = S.possible_leaving()[0]
    S.leave(LEAVE)
    S.update()
    a = self.basic_solution()                             # punkt początkowy
    c = self.objective_coefficients()                     # c to grandient
    for Enter in self.possible_entering():
        C = deepcopy(self)
        C.enter(Enter)
        for Leave in C.possible_leaving():
            P = deepcopy(C)
            P.leave(Leave)
            P.update()
            b = P.basic_solution()
            d = b-a                                       # d to wektor w kierunku danego wierzchołka
            Kat_tmp = np.dot(c,d)/(LA.norm(d)*LA.norm(c)) # kąt jako iloraz iloczynu skalarnego oraz iloczynu norm
            if Kat_tmp < Kat:
                Kat = Kat_tmp
                ENTER = Enter
                LEAVE = Leave
    return ([ENTER, LEAVE])

def gradual_edge_entering(self):
    return gradual_edge(self)[0]

def gradual_edge_leaving(self):
    return gradual_edge(self)[1]

###############################################
# 6 #            BLAND'D RULE                 #
###############################################

def blandd_entering(self):
	return lexicographical_min_entering(self)

def blandd_leaving(self):
	return lexicographical_min_leaving(self)
  
###############################################
# 7 #            RANDOM EDGE                  #
###############################################

def random_edge_entering(self):
    return random.choice(list(self.possible_entering()))
    
def random_edge_leaving(self):
    return random.choice(list(self.possible_leaving()))


###############################################
# 8 #        SMALLEST COEFFICIENT             #
###############################################

def smallest_coefficient_entering(self):
    List = list(self.objective_coefficients())  # wektor współczynników funkcji celu
    Min = List.index(min(List))                 # indeks najmniejszego z nich
    return list(self.nonbasic_variables())[Min] # nazwa zmiennej (spoza bazy) o najmniejszym wsp. f-ji celu

def smallest_coefficient_leaving(self):
    return self.possible_leaving()[0]           # zwracam tak naprawdę cokolwiek xD


#
# Rozne definicje problemow
#
Transporting_Problem = \
    """
    Minimize
    Sum_of_Transporting_Costs: 2 Route_A_1 + 4 Route_A_2 + 5 Route_A_3
     + 2 Route_A_4 + Route_A_5 + 3 Route_B_1 + Route_B_2 + 3 Route_B_3
     + 2 Route_B_4 + 3 Route_B_5
    Subject To
    Sum_of_Products_into_Bar1: Route_A_1 + Route_B_1 >= 500
    Sum_of_Products_into_Bar2: Route_A_2 + Route_B_2 >= 900
    Sum_of_Products_into_Bar3: Route_A_3 + Route_B_3 >= 1800
    Sum_of_Products_into_Bar4: Route_A_4 + Route_B_4 >= 200
    Sum_of_Products_into_Bar5: Route_A_5 + Route_B_5 >= 700
    Sum_of_Products_out_of_Warehouse_A: Route_A_1 + Route_A_2 + Route_A_3
     + Route_A_4 + Route_A_5 <= 1000
    Sum_of_Products_out_of_Warehouse_B: Route_B_1 + Route_B_2 + Route_B_3
     + Route_B_4 + Route_B_5 <= 4000
    Bounds
    Route_A_1 >= 0
    Route_A_2 >= 0
    Route_A_3 >= 0
    Route_A_4 >= 0
    Route_A_5 >= 0
    Route_B_1 >= 0
    Route_B_2 >= 0
    Route_B_3 >= 0
    Route_B_4 >= 0
    Route_B_5 >= 0
    End
    """

##########################################################################################

American_Steel_Problem = \
    """
    Minimize
    Total_Cost_of_Transport: 0.12 Route_('Chicago',_'Gary')
     + 0.6 Route_('Chicago',_'Tempe') + 0.35 Route_('Cincinatti',_'Albany')
     + 0.55 Route_('Cincinatti',_'Houston')
     + 0.375 Route_('Kansas_City',_'Houston')
     + 0.65 Route_('Kansas_City',_'Tempe') + 0.4 Route_('Pittsburgh',_'Chicago')
     + 0.35 Route_('Pittsburgh',_'Cincinatti') + 0.45 Route_('Pittsburgh',_'Gary')
     + 0.45 Route_('Pittsburgh',_'Kansas_City')
     + 0.5 Route_('Youngstown',_'Albany') + 0.375 Route_('Youngstown',_'Chicago')
     + 0.35 Route_('Youngstown',_'Cincinatti')
     + 0.45 Route_('Youngstown',_'Kansas_City')
    Subject To
    Steel_Flow_Conservation_in_Node_Albany: Route_('Cincinatti',_'Albany')
     + Route_('Youngstown',_'Albany') >= 3000
    Steel_Flow_Conservation_in_Node_Chicago: - Route_('Chicago',_'Gary')
     - Route_('Chicago',_'Tempe') + Route_('Pittsburgh',_'Chicago')
     + Route_('Youngstown',_'Chicago') >= 0
    Steel_Flow_Conservation_in_Node_Cincinatti: - Route_('Cincinatti',_'Albany')
     - Route_('Cincinatti',_'Houston') + Route_('Pittsburgh',_'Cincinatti')
     + Route_('Youngstown',_'Cincinatti') >= 0
    Steel_Flow_Conservation_in_Node_Gary: Route_('Chicago',_'Gary')
     + Route_('Pittsburgh',_'Gary') >= 6000
    Steel_Flow_Conservation_in_Node_Houston: Route_('Cincinatti',_'Houston')
     + Route_('Kansas_City',_'Houston') >= 7000
    Steel_Flow_Conservation_in_Node_Kansas_City:
     - Route_('Kansas_City',_'Houston') - Route_('Kansas_City',_'Tempe')
     + Route_('Pittsburgh',_'Kansas_City') + Route_('Youngstown',_'Kansas_City')
     >= 0
    Steel_Flow_Conservation_in_Node_Pittsburgh: - Route_('Pittsburgh',_'Chicago')
     - Route_('Pittsburgh',_'Cincinatti') - Route_('Pittsburgh',_'Gary')
     - Route_('Pittsburgh',_'Kansas_City') >= -15000
    Steel_Flow_Conservation_in_Node_Tempe: Route_('Chicago',_'Tempe')
     + Route_('Kansas_City',_'Tempe') >= 4000
    Steel_Flow_Conservation_in_Node_Youngstown: - Route_('Youngstown',_'Albany')
     - Route_('Youngstown',_'Chicago') - Route_('Youngstown',_'Cincinatti')
     - Route_('Youngstown',_'Kansas_City') >= -10000
    Bounds
    Route_('Chicago',_'Gary') <= 4000
    Route_('Chicago',_'Tempe') <= 2000
    Route_('Cincinatti',_'Albany') <= 5000
    Route_('Cincinatti',_'Houston') <= 6000
    Route_('Kansas_City',_'Houston') <= 4000
    Route_('Kansas_City',_'Tempe') <= 4000
    Route_('Pittsburgh',_'Chicago') <= 4000
    Route_('Pittsburgh',_'Cincinatti') <= 2000
    Route_('Pittsburgh',_'Gary') <= 2000
    Route_('Pittsburgh',_'Kansas_City') <= 3000
    Route_('Youngstown',_'Albany') <= 1000
    Route_('Youngstown',_'Chicago') <= 5000
    Route_('Youngstown',_'Cincinatti') <= 3000
    Route_('Youngstown',_'Kansas_City') <= 5000
    Route_('Chicago',_'Gary') >= 0
    Route_('Chicago',_'Tempe') >= 0
    Route_('Cincinatti',_'Albany') >= 1000
    Route_('Cincinatti',_'Houston') >= 0
    Route_('Kansas_City',_'Houston') >= 0
    Route_('Kansas_City',_'Tempe') >= 0
    Route_('Pittsburgh',_'Chicago') >= 0
    Route_('Pittsburgh',_'Cincinatti') >= 0
    Route_('Pittsburgh',_'Gary') >= 0
    Route_('Pittsburgh',_'Kansas_City') >= 2000
    Route_('Youngstown',_'Albany') >= 0
    Route_('Youngstown',_'Chicago') >= 0
    Route_('Youngstown',_'Cincinatti') >= 0
    Route_('Youngstown',_'Kansas_City') >= 1000
    End
    """

##########################################################################################

Beer_Distribution_Problem = \
    """
    Minimize
    Sum_of_Transporting_Costs: 2 Route_A_1 + 4 Route_A_2 + 5 Route_A_3
     + 2 Route_A_4 + Route_A_5 + 3 Route_B_1 + Route_B_2 + 3 Route_B_3
     + 2 Route_B_4 + 3 Route_B_5
    Subject To
    Sum_of_Products_into_Bar1: Route_A_1 + Route_B_1 >= 500
    Sum_of_Products_into_Bar2: Route_A_2 + Route_B_2 >= 900
    Sum_of_Products_into_Bar3: Route_A_3 + Route_B_3 >= 1800
    Sum_of_Products_into_Bar4: Route_A_4 + Route_B_4 >= 200
    Sum_of_Products_into_Bar5: Route_A_5 + Route_B_5 >= 700
    Sum_of_Products_out_of_Warehouse_A: Route_A_1 + Route_A_2 + Route_A_3
     + Route_A_4 + Route_A_5 <= 1000
    Sum_of_Products_out_of_Warehouse_B: Route_B_1 + Route_B_2 + Route_B_3
     + Route_B_4 + Route_B_5 <= 4000
    Bounds
    Route_A_1 >= 0
    Route_A_2 >= 0
    Route_A_3 >= 0
    Route_A_4 >= 0
    Route_A_5 >= 0
    Route_B_1 >= 0
    Route_B_2 >= 0
    Route_B_3 >= 0
    Route_B_4 >= 0
    Route_B_5 >= 0
    End
    """

##########################################################################################

Computer_Plant_Problem = \
    """
    Minimize
    Total_Costs: 70000 BuildaPlant_Denver + 70000 BuildaPlant_Los_Angeles
     + 65000 BuildaPlant_Phoenix + 70000 BuildaPlant_San_Francisco
     + 8 Route_Denver_Barstow + 5 Route_Denver_Dallas + 9 Route_Denver_San_Diego
     + 6 Route_Denver_Tucson + 7 Route_Los_Angeles_Barstow
     + 10 Route_Los_Angeles_Dallas + 4 Route_Los_Angeles_San_Diego
     + 8 Route_Los_Angeles_Tucson + 5 Route_Phoenix_Barstow
     + 8 Route_Phoenix_Dallas + 6 Route_Phoenix_San_Diego + 3 Route_Phoenix_Tucson
     + 3 Route_San_Francisco_Barstow + 6 Route_San_Francisco_Dallas
     + 5 Route_San_Francisco_San_Diego + 2 Route_San_Francisco_Tucson
    Subject To
    Sum_of_Products_into_Stores_Barstow: Route_Denver_Barstow
     + Route_Los_Angeles_Barstow + Route_Phoenix_Barstow
     + Route_San_Francisco_Barstow >= 1000
    Sum_of_Products_into_Stores_Dallas: Route_Denver_Dallas
     + Route_Los_Angeles_Dallas + Route_Phoenix_Dallas
     + Route_San_Francisco_Dallas >= 1200
    Sum_of_Products_into_Stores_San_Diego: Route_Denver_San_Diego
     + Route_Los_Angeles_San_Diego + Route_Phoenix_San_Diego
     + Route_San_Francisco_San_Diego >= 1700
    Sum_of_Products_into_Stores_Tucson: Route_Denver_Tucson
     + Route_Los_Angeles_Tucson + Route_Phoenix_Tucson
     + Route_San_Francisco_Tucson >= 1500
    Sum_of_Products_out_of_Plant_Denver: - 2000 BuildaPlant_Denver
     + Route_Denver_Barstow + Route_Denver_Dallas + Route_Denver_San_Diego
     + Route_Denver_Tucson <= 0
    Sum_of_Products_out_of_Plant_Los_Angeles: - 2000 BuildaPlant_Los_Angeles
     + Route_Los_Angeles_Barstow + Route_Los_Angeles_Dallas
     + Route_Los_Angeles_San_Diego + Route_Los_Angeles_Tucson <= 0
    Sum_of_Products_out_of_Plant_Phoenix: - 1700 BuildaPlant_Phoenix
     + Route_Phoenix_Barstow + Route_Phoenix_Dallas + Route_Phoenix_San_Diego
     + Route_Phoenix_Tucson <= 0
    Sum_of_Products_out_of_Plant_San_Francisco: - 1700 BuildaPlant_San_Francisco
     + Route_San_Francisco_Barstow + Route_San_Francisco_Dallas
     + Route_San_Francisco_San_Diego + Route_San_Francisco_Tucson <= 0
    Bounds
    Route_Denver_Barstow >= 0
    Route_Denver_Dallas >= 0
    Route_Denver_San_Diego >= 0
    Route_Denver_Tucson >= 0
    Route_Los_Angeles_Barstow >= 0
    Route_Los_Angeles_Dallas >= 0
    Route_Los_Angeles_San_Diego >= 0
    Route_Los_Angeles_Tucson >= 0
    Route_Phoenix_Barstow >= 0
    Route_Phoenix_Dallas >= 0
    Route_Phoenix_San_Diego >= 0
    Route_Phoenix_Tucson >= 0
    Route_San_Francisco_Barstow >= 0
    Route_San_Francisco_Dallas >= 0
    Route_San_Francisco_San_Diego >= 0
    Route_San_Francisco_Tucson >= 0
    End
    """

##########################################################################################

Furniture_Manufacturing_Problem = \
    """
    Maximize
    OBJ: 100 Number_of_Chairs_A + 150 Number_of_Chairs_B
    Subject To
    capacity_of_Lathe: Number_of_Chairs_A + 2 Number_of_Chairs_B <= 40
    capacity_of_Polisher: 3 Number_of_Chairs_A + 1.5 Number_of_Chairs_B <= 48
    End
    """

##########################################################################################

GAMSMOD_Problem = \
    """
    Minimize
     R0000115: + C0000061

    Subject To
     R0000001: - C0000001 + C0000002 <= 3.818181818
     R0000002: - C0000002 + C0000003 <= 3.818181818
     R0000003: - C0000003 + C0000004 <= 3.818181818
     R0000004: - C0000004 + C0000005 <= 3.818181818
     R0000005: - C0000005 + C0000006 <= 3.818181818
     R0000006: - C0000006 + C0000007 <= 3.818181818
     R0000007: - C0000007 + C0000008 <= 3.818181818
     R0000008: - C0000008 + C0000009 <= 3.818181818
     R0000009: - C0000009 + C0000010 <= 3.818181818
     R0000010: - C0000011 + C0000012 <= 3.818181818
     R0000011: - C0000012 + C0000013 <= 3.818181818
     R0000012: - C0000013 + C0000014 <= 3.818181818
     R0000013: - C0000014 + C0000015 <= 3.818181818
     R0000014: - C0000015 + C0000016 <= 3.818181818
     R0000015: - C0000016 + C0000017 <= 3.818181818
     R0000016: - C0000017 + C0000018 <= 3.818181818
     R0000017: - C0000018 + C0000019 <= 3.818181818
     R0000018: - C0000019 + C0000020 <= 3.818181818
     R0000019: - C0000021 + C0000022 <= 3.818181818
     R0000020: - C0000022 + C0000023 <= 3.818181818
     R0000021: - C0000023 + C0000024 <= 3.818181818
     R0000022: - C0000024 + C0000025 <= 3.818181818
     R0000023: - C0000025 + C0000026 <= 3.818181818
     R0000024: - C0000026 + C0000027 <= 3.818181818
     R0000025: - C0000027 + C0000028 <= 3.818181818
     R0000026: - C0000028 + C0000029 <= 3.818181818
     R0000027: - C0000029 + C0000030 <= 3.818181818
     R0000028: - C0000031 + C0000032 <= 4.290909091
     R0000029: - C0000032 + C0000033 <= 4.290909091
     R0000030: - C0000033 + C0000034 <= 4.290909091
     R0000031: - C0000034 + C0000035 <= 4.290909091
     R0000032: - C0000035 + C0000036 <= 4.290909091
     R0000033: - C0000036 + C0000037 <= 4.290909091
     R0000034: - C0000037 + C0000038 <= 4.290909091
     R0000035: - C0000038 + C0000039 <= 4.290909091
     R0000036: - C0000039 + C0000040 <= 4.290909091
     R0000037: - C0000041 + C0000042 <= 4.290909091
     R0000038: - C0000042 + C0000043 <= 4.290909091
     R0000039: - C0000043 + C0000044 <= 4.290909091
     R0000040: - C0000044 + C0000045 <= 4.290909091
     R0000041: - C0000045 + C0000046 <= 4.290909091
     R0000042: - C0000046 + C0000047 <= 4.290909091
     R0000043: - C0000047 + C0000048 <= 4.290909091
     R0000044: - C0000048 + C0000049 <= 4.290909091
     R0000045: - C0000049 + C0000050 <= 4.290909091
     R0000046: - C0000051 + C0000052 <= 4.290909091
     R0000047: - C0000052 + C0000053 <= 4.290909091
     R0000048: - C0000053 + C0000054 <= 4.290909091
     R0000049: - C0000054 + C0000055 <= 4.290909091
     R0000050: - C0000055 + C0000056 <= 4.290909091
     R0000051: - C0000056 + C0000057 <= 4.290909091
     R0000052: - C0000057 + C0000058 <= 4.290909091
     R0000053: - C0000058 + C0000059 <= 4.290909091
     R0000054: - C0000059 + C0000060 <= 4.290909091
     R0000055: - C0000001 + C0000002 >= -3.818181818
     R0000056: - C0000002 + C0000003 >= -3.818181818
     R0000057: - C0000003 + C0000004 >= -3.818181818
     R0000058: - C0000004 + C0000005 >= -3.818181818
     R0000059: - C0000005 + C0000006 >= -3.818181818
     R0000060: - C0000006 + C0000007 >= -3.818181818
     R0000061: - C0000007 + C0000008 >= -3.818181818
     R0000062: - C0000008 + C0000009 >= -3.818181818
     R0000063: - C0000009 + C0000010 >= -3.818181818
     R0000064: - C0000011 + C0000012 >= -3.818181818
     R0000065: - C0000012 + C0000013 >= -3.818181818
     R0000066: - C0000013 + C0000014 >= -3.818181818
     R0000067: - C0000014 + C0000015 >= -3.818181818
     R0000068: - C0000015 + C0000016 >= -3.818181818
     R0000069: - C0000016 + C0000017 >= -3.818181818
     R0000070: - C0000017 + C0000018 >= -3.818181818
     R0000071: - C0000018 + C0000019 >= -3.818181818
     R0000072: - C0000019 + C0000020 >= -3.818181818
     R0000073: - C0000021 + C0000022 >= -3.818181818
     R0000074: - C0000022 + C0000023 >= -3.818181818
     R0000075: - C0000023 + C0000024 >= -3.818181818
     R0000076: - C0000024 + C0000025 >= -3.818181818
     R0000077: - C0000025 + C0000026 >= -3.818181818
     R0000078: - C0000026 + C0000027 >= -3.818181818
     R0000079: - C0000027 + C0000028 >= -3.818181818
     R0000080: - C0000028 + C0000029 >= -3.818181818
     R0000081: - C0000029 + C0000030 >= -3.818181818
     R0000082: - C0000031 + C0000032 >= -4.290909091
     R0000083: - C0000032 + C0000033 >= -4.290909091
     R0000084: - C0000033 + C0000034 >= -4.290909091
     R0000085: - C0000034 + C0000035 >= -4.290909091
     R0000086: - C0000035 + C0000036 >= -4.290909091
     R0000087: - C0000036 + C0000037 >= -4.290909091
     R0000088: - C0000037 + C0000038 >= -4.290909091
     R0000089: - C0000038 + C0000039 >= -4.290909091
     R0000090: - C0000039 + C0000040 >= -4.290909091
     R0000091: - C0000041 + C0000042 >= -4.290909091
     R0000092: - C0000042 + C0000043 >= -4.290909091
     R0000093: - C0000043 + C0000044 >= -4.290909091
     R0000094: - C0000044 + C0000045 >= -4.290909091
     R0000095: - C0000045 + C0000046 >= -4.290909091
     R0000096: - C0000046 + C0000047 >= -4.290909091
     R0000097: - C0000047 + C0000048 >= -4.290909091
     R0000098: - C0000048 + C0000049 >= -4.290909091
     R0000099: - C0000049 + C0000050 >= -4.290909091
     R0000100: - C0000051 + C0000052 >= -4.290909091
     R0000101: - C0000052 + C0000053 >= -4.290909091
     R0000102: - C0000053 + C0000054 >= -4.290909091
     R0000103: - C0000054 + C0000055 >= -4.290909091
     R0000104: - C0000055 + C0000056 >= -4.290909091
     R0000105: - C0000056 + C0000057 >= -4.290909091
     R0000106: - C0000057 + C0000058 >= -4.290909091
     R0000107: - C0000058 + C0000059 >= -4.290909091
     R0000108: - C0000059 + C0000060 >= -4.290909091
     R0000109: + 0.381818182 C0000001 + 0.381818182 C0000002
     + 0.381818182 C0000003 + 0.381818182 C0000004 + 0.381818182 C0000005
     + 0.381818182 C0000006 + 0.381818182 C0000007 + 0.381818182 C0000008
     + 0.381818182 C0000009 + 0.381818182 C0000010 - 0.429090909 C0000031
     - 0.429090909 C0000032 - 0.429090909 C0000033 - 0.429090909 C0000034
     - 0.429090909 C0000035 - 0.429090909 C0000036 - 0.429090909 C0000037
     - 0.429090909 C0000038 - 0.429090909 C0000039 - 0.429090909 C0000040
     = -15.73818182
     R0000110: + 0.381818182 C0000011 + 0.381818182 C0000012
     + 0.381818182 C0000013 + 0.381818182 C0000014 + 0.381818182 C0000015
     + 0.381818182 C0000016 + 0.381818182 C0000017 + 0.381818182 C0000018
     + 0.381818182 C0000019 + 0.381818182 C0000020 - 0.429090909 C0000041
     - 0.429090909 C0000042 - 0.429090909 C0000043 - 0.429090909 C0000044
     - 0.429090909 C0000045 - 0.429090909 C0000046 - 0.429090909 C0000047
     - 0.429090909 C0000048 - 0.429090909 C0000049 - 0.429090909 C0000050
     = 14.94545455
     R0000111: + 0.381818182 C0000021 + 0.381818182 C0000022
     + 0.381818182 C0000023 + 0.381818182 C0000024 + 0.381818182 C0000025
     + 0.381818182 C0000026 + 0.381818182 C0000027 + 0.381818182 C0000028
     + 0.381818182 C0000029 + 0.381818182 C0000030 - 0.429090909 C0000051
     - 0.429090909 C0000052 - 0.429090909 C0000053 - 0.429090909 C0000054
     - 0.429090909 C0000055 - 0.429090909 C0000056 - 0.429090909 C0000057
     - 0.429090909 C0000058 - 0.429090909 C0000059 - 0.429090909 C0000060
     = 0
     R0000112: + 0.429090909 C0000031 + 0.429090909 C0000032
     + 0.429090909 C0000033 + 0.429090909 C0000034 + 0.429090909 C0000035
     + 0.429090909 C0000036 + 0.429090909 C0000037 + 0.429090909 C0000038
     + 0.429090909 C0000039 + 0.429090909 C0000040 <= 12.68363636
     R0000113: + 0.429090909 C0000031 + 0.429090909 C0000032
     + 0.429090909 C0000033 + 0.429090909 C0000034 + 0.429090909 C0000035
     + 0.429090909 C0000036 + 0.429090909 C0000037 + 0.429090909 C0000038
     + 0.429090909 C0000039 + 0.429090909 C0000040 >= -4.100979036
     R0000114: + C0000061 = 1

    Bounds
     C0000001 <= 10
     C0000002 <= 10
     C0000003 <= 10
     C0000004 <= 10
     C0000005 <= 10
     C0000006 <= 10
     C0000007 <= 10
     C0000008 <= 10
     C0000009 <= 10
     C0000010 <= 10
     C0000011 <= 3.818181818
     C0000012 <= 7.636363636
     C0000013 <= 10
     C0000014 <= 10
     C0000015 <= 10
     C0000016 <= 10
     C0000017 <= 10
     C0000018 <= 10
     C0000019 <= 7.636363636
     C0000020 <= 3.818181818
     C0000021 <= 3.818181818
     C0000022 <= 7.636363636
     C0000023 <= 10
     C0000024 <= 10
     C0000025 <= 10
     C0000026 <= 10
     C0000027 <= 10
     C0000028 <= 10
     C0000029 <= 7.636363636
     C0000030 <= 3.818181818
     C0000031 <= 10
     C0000032 <= 10
     C0000033 <= 10
     C0000034 <= 10
     C0000035 <= 10
     C0000036 <= 10
     C0000037 <= 10
     C0000038 <= 10
     C0000039 <= 8.581818182
     C0000040 <= 4.290909091
     C0000041 <= 4.290909091
     C0000042 <= 8.581818182
     C0000043 <= 10
     C0000044 <= 10
     C0000045 <= 10
     C0000046 <= 10
     C0000047 <= 10
     C0000048 <= 10
     C0000049 <= 10
     C0000050 <= 10
     C0000051 <= 4.290909091
     C0000052 <= 8.581818182
     C0000053 <= 10
     C0000054 <= 10
     C0000055 <= 10
     C0000056 <= 10
     C0000057 <= 10
     C0000058 <= 10
     C0000059 <= 8.581818182
     C0000060 <= 4.290909091
     C0000001 >= 4.181818182 
     C0000002 >= 0.363636364 
     C0000003 >= -3.454545455 
     C0000004 >= -7.272727273 
     C0000005 >= -10
     C0000006 >= -10
     C0000007 >= -7.272727273 
     C0000008 >= -3.454545455 
     C0000009 >= 0.363636364 
     C0000010 >= 4.181818182 
     C0000011 >= -3.818181818
     C0000012 >= -7.636363636
     C0000013 >= -10
     C0000014 >= -10
     C0000015 >= -10
     C0000016 >= -10
     C0000017 >= -10
     C0000018 >= -10
     C0000019 >= -7.636363636
     C0000020 >= -3.818181818
     C0000021 >= -3.818181818
     C0000022 >= -7.636363636
     C0000023 >= -10
     C0000024 >= -10
     C0000025 >= -10
     C0000026 >= -10
     C0000027 >= -10
     C0000028 >= -10
     C0000029 >= -7.636363636
     C0000030 >= -3.818181818
     C0000031 >= 3.709090909 
     C0000032 >= -0.581818182 
     C0000033 >= -4.872727273 
     C0000034 >= -9.163636364 
     C0000035 >= -10
     C0000036 >= -10
     C0000037 >= -10
     C0000038 >= -10
     C0000039 >= -8.581818182
     C0000040 >= -4.290909091
     C0000041 >= -4.290909091
     C0000042 >= -8.581818182
     C0000043 >= -10
     C0000044 >= -10
     C0000045 >= -10
     C0000046 >= -10
     C0000047 >= -7.163636364 
     C0000048 >= -2.872727273 
     C0000049 >= 1.418181818 
     C0000050 >= 5.709090909 
     C0000051 >= -4.290909091
     C0000052 >= -8.581818182
     C0000053 >= -10
     C0000054 >= -10
     C0000055 >= -10
     C0000056 >= -10
     C0000057 >= -10
     C0000058 >= -10
     C0000059 >= -8.581818182
     C0000060 >= -4.290909091
    End
    """

##########################################################################################

Cutting_Stock_Problem = \
    """
    Minimize
    Net_Production_Cost: 0.2 Patt_P0 + 0.56 Patt_P1 + 0.6 Patt_P10 + 0.96 Patt_P11
     + 0.88 Patt_P12 + 0.8 Patt_P13 + Patt_P14 + 0.92 Patt_P2 + 0.48 Patt_P3
     + 0.84 Patt_P4 + 0.76 Patt_P5 + 0.4 Patt_P6 + 0.76 Patt_P7 + 0.68 Patt_P8
     + 0.96 Patt_P9 - 0.25 Surp_5 - 0.33 Surp_7 - 0.4 Surp_9
    Subject To
    Ensuring_enough_5_cm_rolls: 2 Patt_P10 + 2 Patt_P11 + 2 Patt_P12 + 3 Patt_P13
     + 4 Patt_P14 + Patt_P6 + Patt_P7 + Patt_P8 + Patt_P9 - Surp_5 >= 150
    Ensuring_enough_7_cm_rolls: Patt_P12 + Patt_P3 + Patt_P4 + 2 Patt_P5 + Patt_P8
     + 2 Patt_P9 - Surp_7 >= 200
    Ensuring_enough_9_cm_rolls: Patt_P1 + Patt_P11 + 2 Patt_P2 + Patt_P4 + Patt_P7
     - Surp_9 >= 300
    Bounds
    Patt_P0 >= 0
    Patt_P1 >= 0
    Patt_P10 >= 0
    Patt_P11 >= 0
    Patt_P12 >= 0
    Patt_P13 >= 0
    Patt_P14 >= 0
    Patt_P2 >= 0
    Patt_P3 >= 0
    Patt_P4 >= 0
    Patt_P5 >= 0
    Patt_P6 >= 0
    Patt_P7 >= 0
    Patt_P8 >= 0
    Patt_P9 >= 0
    Surp_5 >= 0
    Surp_7 >= 0
    Surp_9 >= 0
    End
    """

##########################################################################################

Whiskas_Problem_1 = \
    """
    Minimize
    Total_Cost_of_Ingredients_per_can: 0.008 BeefPercent + 0.013 ChickenPercent
    Subject To
    FatRequirement: 0.1 BeefPercent + 0.08 ChickenPercent >= 6
    FibreRequirement: 0.005 BeefPercent + 0.001 ChickenPercent <= 2
    PercentagesSum: BeefPercent + ChickenPercent = 100
    ProteinRequirement: 0.2 BeefPercent + 0.1 ChickenPercent >= 8
    SaltRequirement: 0.005 BeefPercent + 0.002 ChickenPercent <= 0.4
    Bounds
    ChickenPercent >= 0
    End
    """

##########################################################################################

Whiskas_Problem_2 = \
    """
    Minimize
    Total_Cost_of_Ingredients_per_can: 0.008 Ingr_BEEF + 0.013 Ingr_CHICKEN
     + 0.001 Ingr_GEL + 0.01 Ingr_MUTTON + 0.002 Ingr_RICE + 0.005 Ingr_WHEAT
    Subject To
    FatRequirement: 0.1 Ingr_BEEF + 0.08 Ingr_CHICKEN + 0.11 Ingr_MUTTON
     + 0.01 Ingr_RICE + 0.01 Ingr_WHEAT >= 6
    FibreRequirement: 0.005 Ingr_BEEF + 0.001 Ingr_CHICKEN + 0.003 Ingr_MUTTON
     + 0.1 Ingr_RICE + 0.15 Ingr_WHEAT <= 2
    PercentagesSum: Ingr_BEEF + Ingr_CHICKEN + Ingr_GEL + Ingr_MUTTON + Ingr_RICE
     + Ingr_WHEAT = 100
    ProteinRequirement: 0.2 Ingr_BEEF + 0.1 Ingr_CHICKEN + 0.15 Ingr_MUTTON
     + 0.04 Ingr_WHEAT >= 8
    SaltRequirement: 0.005 Ingr_BEEF + 0.002 Ingr_CHICKEN + 0.007 Ingr_MUTTON
     + 0.002 Ingr_RICE + 0.008 Ingr_WHEAT <= 0.4
    End
    """
	
    #######################################
 #############################################
##                                           ##
#              WYBOR PROBLEMU                 #
##                                           ##
 #############################################
    #######################################

PROBLEMY = ([Transporting_Problem,
             Beer_Distribution_Problem,
             Computer_Plant_Problem,
             Furniture_Manufacturing_Problem,
             Whiskas_Problem_1,
             Whiskas_Problem_2,
             American_Steel_Problem,
             GAMSMOD_Problem,
             Cutting_Stock_Problem,])
PROBLEM_nazwa = (["Transporting_Problem",
                   "Beer_Distribution_Problem",
                   "Computer_Plant_Problem",
                   "Furniture_Manufacturing_Problem",
                   "Whiskas_Problem_1",
                   "Whiskas_Problem_2",
                   "American_Steel_Problem",
                   "GAMSMOD_Problem",
                   "Cutting_Stock_Problem"])

    #######################################
 #############################################
##                                           ##
#            WYBOR FUNKCJI PIVOT              #
##                                           ##
 #############################################
    #######################################
    

def PIVOT_ENTERING(self):
    return ([lexicographical_max_entering(self),
             largest_coefficient_entering(self),
             largest_increase_entering(self),
             smallest_increase_entering(self),
             steepest_edge_entering(self),
             gradual_edge_entering(self),
             blandd_entering(self)])

def PIVOT_LEAVING(self):
    return ([lexicographical_max_leaving(self),
             largest_coefficient_leaving(self),
             largest_increase_leaving(self),
             smallest_increase_leaving(self),
             steepest_edge_leaving(self),
             gradual_edge_leaving(self),
             blandd_leaving(self)])

PIVOT_nazwa = (["leksykograficzny (maximum)",
          "LARGEST COEFFICIENT",
          "LARGEST INCREASE",
          "SMALLEST INCREASE",
          "STEEPEST EDGE",
          "MOST GRADUAL EDGE",
          "BLAND'D RULE",
          "RANDOM EDGE",
          "SMALLEST COEFFICIENT"])
    
for M in range(9):
    print "\n\n############################    ", PROBLEM_nazwa[M], "    ############################\n"
    
    for N in range(7):
        print "\n\n                  ", PIVOT_nazwa[N], "\n"

        def my_entering(self):
            return PIVOT_ENTERING(self)[N]

        def my_leaving(self):
            return PIVOT_LEAVING(self)[N]

        #
        # Definicja problemu
        #

        LP = PROBLEMY[M]

        from sage.misc.html import HtmlFragment
        import types

        def my_run_simplex_method(self):
            output = []
            while not self.is_optimal():
                self.pivots += 1
                if self.entering() is None:
                    self.enter(self.pivot_select_entering())
                if self.leaving() is None:
                    if self.possible_leaving():
                        self.leave(self.pivot_select_leaving())

                output.append(self._html_())
                if self.leaving() is None:
                    output.append("The problem is unbounded in $()$ direction.".format(latex(self.entering())))
                    break
                output.append(self._preupdate_output("primal"))
                self.update()
            if self.is_optimal():
                output.append(self._html_())
            return HtmlFragment("\n".join(output))

        #
        # Parsowanie danych
        #

        class Matrix:
            """ output matrix class """

            class Objective:
                def __init__(self, expression, sense, name):
                    if name:
                        self.name = name[int(0)]
                    else:
                        self.name = ""
                    self.sense = sense # 1 is minimise, -1 is maximise
                    self.expression = expression # a dict with variable names as keys, and coefficients as values

            class Constraint:
                def __init__(self, expression, sense, rhs, name):
                    if name:
                        self.name = name[int(0)]
                    else:
                        self.name = ""
                    self.sense = sense # 1 is geq, 0 is eq, -1 is leq
                    self.rhs = rhs
                    self.expression = expression

            class Variable:
                def __init__(self, bounds, category, name):
                    self.name = name
                    self.bounds = (bounds["lb"], bounds["ub"]) # a tuple (lb, ub)
                    self.category = category # 1 for int, 0 for linear

            def __init__(self, parserObjective, parserConstraints, parserBounds, parserGenerals, parserBinaries):

                self.objective = Matrix.Objective(varExprToDict(parserObjective.varExpr), objSenses[parserObjective.objSense], parserObjective.name)

                self.constraints = [Matrix.Constraint(varExprToDict(c.varExpr), constraintSenses[c.sense], c.rhs, c.name) for c in parserConstraints]

                boundDict = getBoundDict(parserBounds, parserBinaries) # can't get parser to generate this dict because one var can have several bound statements

                allVarNames = set()
                allVarNames.update(self.objective.expression.keys())
                for c in self.constraints:
                    allVarNames.update(c.expression.keys())
                allVarNames.update(parserGenerals)
                allVarNames.update(boundDict.keys())

                self.variables = [Matrix.Variable(boundDict[vName], ((vName in list(parserGenerals)) or (vName in list(parserBinaries))), vName) for vName in allVarNames]

            def __repr__(self):
                return "Objective%s\n\nConstraints (%d)%s\n\nVariables (%d)%s" \
                %("\n%s %s %s"%(self.objective.sense, self.objective.name, str(self.objective.expression)), \
                  len(self.constraints), \
                  "".join(["\n(%s, %s, %s, %s)"%(c.name, str(c.expression), c.sense, c.rhs) for c in self.constraints]), \
                  len(self.variables), \
                  "".join(["\n(%s, %s, %s)"%(v.name, str(v.bounds), v.category) for v in self.variables]))

            def getInteractiveLPProblem(self):
                A = [[0 for x in range(len(self.variables))] for y in range(len(self.constraints))]
                b = [0] * len(self.constraints)
                c = [0] * len(self.variables)

                for i, constraint in enumerate(self.constraints):
                    for v, a in constraint.expression.iteritems():
                        if constraint.sense == 1:
                            A[i][map(lambda x: x.name, self.variables).index(v)] = -a
                        else:
                            A[i][map(lambda x: x.name, self.variables).index(v)] = a

                        if constraint.sense == 1:		
                            b[i] = -constraint.rhs
                        else:
                            b[i] = constraint.rhs 

                for v, a in self.objective.expression.iteritems():
                    if self.objective.sense == 1:
                        c[map(lambda x: x.name, self.variables).index(v)] = -a
                    else:
                        c[map(lambda x: x.name, self.variables).index(v)] = a

                AA = ()
                bb = ()
                cc = ()

                for a in A:
                    aaa=[]
                    for aa in a:
                        aaa.append(aa*int(10000))        
                    AA = AA + (list(aaa),)
                for b in b:
                    bb = bb + (b*int(10000),)
                for c in c:
                    cc = cc + (c*int(10000),)

                lpp = InteractiveLPProblemStandardForm(AA,bb,cc)

                for i, v in enumerate(self.variables):
                    if v.bounds[int(1)] < infinity:
                        coef = [0,] * len(self.variables)
                        coef[i] = 1
                        lpp = lpp.add_constraint((coef), v.bounds[int(1)]*int(10000))
                    if v.bounds[int(0)] > -infinity:
                        coef = [0,] * len(self.variables)
                        coef[i] = -1
                        lpp = lpp.add_constraint((coef), -v.bounds[int(0)]*int(10000))

                return lpp

        def varExprToDict(varExpr):
            return dict((v.name[int(0)], v.coef) for v in varExpr)

        def getBoundDict(parserBounds, parserBinaries):
            boundDict = defaultdict(lambda: {"lb": -infinity, "ub": infinity}) # need this versatility because the lb and ub can come in separate bound statements

            for b in parserBounds:
                bName = b.name[int(0)]

                # if b.free, default is fine

                if b.leftbound:
                    if constraintSenses[b.leftbound.sense] >= 0: # NUM >= var
                        boundDict[bName]["ub"] = b.leftbound.numberOrInf

                    if constraintSenses[b.leftbound.sense] <= 0: # NUM <= var
                        boundDict[bName]["lb"] = b.leftbound.numberOrInf

                if b.rightbound:
                    if constraintSenses[b.rightbound.sense] >= 0: # var >= NUM
                        boundDict[bName]["lb"] = b.rightbound.numberOrInf

                    if constraintSenses[b.rightbound.sense] <= 0: # var <= NUM
                        boundDict[bName]["ub"] = b.rightbound.numberOrInf

            for bName in parserBinaries:
                boundDict[bName]["lb"] = 0
                boundDict[bName]["ub"] = 1

            return boundDict


        def multiRemove(baseString, removables):
            """ replaces an iterable of strings in removables 
                if removables is a string, each character is removed """
            for r in removables:
                try:
                    baseString = baseString.replace(r, "")
                except TypeError:
                    raise TypeError, "Removables contains a non-string element"
            return baseString

        from pyparsing import *
        from sys import argv, exit
        from collections import defaultdict

        MINIMIZE = 1
        MAXIMIZE = -1

        objSenses = {"max": MAXIMIZE, "maximum": MAXIMIZE, "maximize": MAXIMIZE, \
                     "min": MINIMIZE, "minimum": MINIMIZE, "minimize": MINIMIZE}

        GEQ = 1
        EQ = 0
        LEQ = -1

        constraintSenses = {"<": LEQ, "<=": LEQ, "=<": LEQ, \
                            "=": EQ, \
                            ">": GEQ, ">=": GEQ, "=>": GEQ}

        infinity = 1E30

        def read(fullDataString):
            #name char ranges for objective, constraint or variable
            allNameChars = alphanums + "!\"#$%&()/,.;?@_'`{}|~"
            firstChar = multiRemove(allNameChars, nums + "eE.") #<- can probably use CharsNotIn instead
            name = Word(firstChar, allNameChars, max=255)
            keywords = ["inf", "infinity", "max", "maximum", "maximize", "min", "minimum", "minimize", "s.t.", "st", "bound", "bounds", "bin", "binaries", "binary", "gen",  "general", "end"]
            pyKeyword = MatchFirst(map(CaselessKeyword, keywords))
            validName = ~pyKeyword + name
            validName = validName.setResultsName("name")

            colon = Suppress(oneOf(": ::"))
            plusMinus = oneOf("+ -")
            inf = oneOf("inf infinity", caseless=True)
            number = Word(nums+".")
            sense = oneOf("< <= =< = > >= =>").setResultsName("sense")

            # section tags
            objTagMax = oneOf("max maximum maximize", caseless=True)
            objTagMin = oneOf("min minimum minimize", caseless=True)
            objTag = (objTagMax | objTagMin).setResultsName("objSense")

            constraintsTag = oneOf(["subj to", "subject to", "s.t.", "st"], caseless=True)

            boundsTag = oneOf("bound bounds", caseless=True)
            binTag = oneOf("bin binaries binary", caseless=True)
            genTag = oneOf("gen general", caseless=True)

            endTag = CaselessLiteral("end")

            # coefficient on a variable (includes sign)
            firstVarCoef = Optional(plusMinus, "+") + Optional(number, "1")
            firstVarCoef.setParseAction(lambda tokens: eval("".join(tokens))) #TODO: can't this just be eval(tokens[0] + tokens[1])?

            coef = plusMinus + Optional(number, "1")
            coef.setParseAction(lambda tokens: eval("".join(tokens))) #TODO: can't this just be eval(tokens[0] + tokens[1])?

            # variable (coefficient and name)
            firstVar = Group(firstVarCoef.setResultsName("coef") + validName)
            var = Group(coef.setResultsName("coef") + validName)

            # expression
            varExpr = firstVar + ZeroOrMore(var)
            varExpr = varExpr.setResultsName("varExpr")

            # objective
            objective = objTag + Optional(validName + colon) + varExpr
            objective = objective.setResultsName("objective")

            # constraint rhs
            rhs = Optional(plusMinus, "+") + number
            rhs = rhs.setResultsName("rhs")
            rhs.setParseAction(lambda tokens: eval("".join(tokens)))

            # constraints
            constraint = Group(Optional(validName + colon) + varExpr + sense + rhs)
            constraints = ZeroOrMore(constraint)
            constraints = constraints.setResultsName("constraints")

            # bounds
            signedInf = (plusMinus + inf).setParseAction(lambda tokens:(tokens[int(0)] == "+") * infinity)
            signedNumber = (Optional(plusMinus, "+") + number).setParseAction(lambda tokens: eval("".join(tokens)))  # this is different to previous, because "number" is mandatory not optional
            numberOrInf = (signedNumber | signedInf).setResultsName("numberOrInf")
            ineq = numberOrInf & sense
            sensestmt = Group(Optional(ineq).setResultsName("leftbound") + validName + Optional(ineq).setResultsName("rightbound"))
            freeVar = Group(validName + Literal("free"))

            boundstmt = freeVar | sensestmt 
            bounds = boundsTag + ZeroOrMore(boundstmt).setResultsName("bounds")

            # generals
            generals = genTag + ZeroOrMore(validName).setResultsName("generals") 

            # binaries
            binaries = binTag + ZeroOrMore(validName).setResultsName("binaries")

            varInfo = ZeroOrMore(bounds | generals | binaries)

            grammar = objective + constraintsTag + constraints + varInfo + endTag

            # commenting
            commentStyle = Literal("\\") + restOfLine
            grammar.ignore(commentStyle)

            # parse input string
            parseOutput = grammar.parseString(fullDataString)

            # create generic output Matrix object
            m = Matrix(parseOutput.objective, parseOutput.constraints, parseOutput.bounds, parseOutput.generals, parseOutput.binaries)

            return m

        #
        # Parsowanie danych
        #

        m = read(LP)
        P = m.getInteractiveLPProblem()

        #
        # Ustawienie wlasnej funkcji pivot
        #

        D = P.initial_dictionary()

        if not D.is_feasible():
            print "The initial dictionary is infeasible, solving auxiliary problem."
            # Phase I
            AD = P.auxiliary_problem().initial_dictionary()
            AD.enter(P.auxiliary_variable())
            AD.leave(min(zip(AD.constant_terms(), AD.basic_variables()))[int(1)])
            AD.run_simplex_method()
            if AD.objective_value() < 0:
                print "The original problem is infeasible."
                P._final_dictionary = AD
            else:
                print "Back to the original problem."
                D = P.feasible_dictionary(AD)


        D.run_simplex_method = types.MethodType(my_run_simplex_method, D)
        D.pivots = 0

        D.pivot_select_entering = types.MethodType(my_entering, D)
        D.pivot_select_leaving = types.MethodType(my_leaving, D)

        #
        # Algorytm sympleks
        #

        if D.is_feasible():
            D.run_simplex_method()

        print "Number of pivot steps: ", D.pivots

        print D.objective_value()
        print P.optimal_solution()
