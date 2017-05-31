# GRAF

Rozwiązanie problemu dualnego do danego w zadaniu 1 (które ten program również rozwiązuje) wskazuje na wierzchołki (prymalny "mówił" o krawędziach) jednej z grup w grafie dwudzielnym, gdyż poprzez takie warunki nałożone na krawędzie (nawet z pominiętymi wagami) tworzymy coś w rodzaju bijekcji między tymi grupami wierzchołków, zatem z punktu widzenia danej grupy wszystko to, co "widzą" wierzchołki w niej zawarte to zbiór wszystkich krawędzi całego grafu. Gdyby te grupy nie były równoliczne, to ów algorytm wskazałby mniejsząz nich, co z oczywistych względów jest optymalnym pokryciem, którego szukamy. Wartość funkcji celu mojego programu to minus liczba wierzchołków w mniejszej z grup grafu (bądź liczba krawędzi w grafie po qnałożeniu na nie warunków zadania pierwszego z tego labu).

Program jest pod linkiem https://cocalc.com/projects/ac1be6fd-371e-444c-94f2-6bb5ee05dddd/files/graph.sagews
ale wykrzacza się wyświetlanie, więc polecam wziąć kod i uruchomić tu: https://sagecell.sagemath.org/ (mniejsze limity na output)

Program zawiera liczbę n
aby rozwiązywał "całe" zadanie pierwsze i trzecie powinna ona wynosić 7 (wymiar macierzy incydencji grafu z polecenia). Ja ją zmniejszyłem (wziąłem minor główny tej macierzy o wym 3x3), bo się wszystko strasznie długo liczyło i mało było widać. ;-)
