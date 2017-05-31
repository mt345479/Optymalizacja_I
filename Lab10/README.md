# WIERZCHOŁKI
Powyższy program realizuje optymalizację algorytmu w postaci kanonicznej metodą przeglądania wszystkich wierzchołków.

Należy zadeklarować znormalizowany układ oraz funkcję celu zadające badany problem.
Dla przykładu układ z zadania:

========================================================

    octave:1> A = [-1 1 1 0 0 ; 1 0 0 1 0 ; 0 1 0 0 1]
    A =

      -1   1   1   0   0
       1   0   0   1   0
       0   1   0   0   1

    octave:2> b = [1;3;2]
    b =

       1
       3
       2
    octave:3> F = @(x)(x(1)+x(2))
    F =

    @(x) (x (1) + x (2))

========================================================

Następnie wywołujemy funkcję:

========================================================

    octave:4> wierzcholki(A, b, F)
    uklad_lewa_str =

      -1   1   1   0   0
       1   0   0   1   0
       0   1   0   0   1

    uklad_prawa_str =

       1
       3
       2

    maksymalny_wierzcholek =

      -1   1   1
       1   0   0
       0   1   0

    maksymalny_wektor_ =

       3
       2
       2
       0
       0

    F_max =  5
========================================================

Program można wygodnie wywołać online np. na stronie:

http://octave-online.net/ (po zalogowaniu przez konto Google)
