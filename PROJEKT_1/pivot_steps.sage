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
    Kat = 1000                                             # miara kąta między wektorem i gradientem
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
    
def my_entering(self):
    return PIVOT_ENTERING(self)[5]

def my_leaving(self):
    return PIVOT_LEAVING(self)[5]

#
# Definicja problemu
#

LP = \
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

#with open('problem.lp', 'r') as lpfile:
#    LP=lpfile.read()

##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################

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