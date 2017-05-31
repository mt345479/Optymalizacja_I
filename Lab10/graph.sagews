
%typeset_mode True

M = ([57,87,0,75,0,0,0], [0,0,96,0,55,85,0], [48,0,74,0,0,0,64], [0,70,0,81,0,0,0], [0,0,60,0,0,26,0], [95,0,0,0,0,60,0], [0,0,0,90,75,0,88])
show (matrix(M))

n = 3

# przepisuje macierz na jeden wektor wiersz po wierszu

d = matrix(1,n*n).row(0)
for i in range(n):
    for j in range(n):
        d[n*i+j] = matrix(M)[i,j]
show (d)
        
# Tworzę 'pusty' problem sympleks

A = zero_matrix(1,n*n)
b = (0,)
c = ones_matrix(1,n*n).row(0)
P = InteractiveLPProblem(A, b, d)

# Wypełniam problem nierównościami na jedną '1':
#   w wierszu
for i in range(n):
    v = zero_matrix(1,n*n).row(0)
    for j in range(n):
        v[n*i+j] = 1
    P = P.add_constraint(v, 1 , "==")
    #P = P.add_constraint(-v, 1 , "<=")
    
#   w kolumnie
for i in range(n):
    w = zero_matrix(1,n*n).row(0)
    for j in range(n):
        w[i+n*j] = 1
    P = P.add_constraint(w, 1 , "==")
    #P = P.add_constraint(-w, 1 , "<=")


# Przepisuje, bo nie lubię standaryzacji gotową funkcją, jeśli nie jest konieczna
R = InteractiveLPProblemStandardForm(P.A(), ones_matrix(2*n+1,1).column(0), d)

# Problem prymalny
show(R.Abcx())

# Problem dualny
RD = InteractiveLPProblemStandardForm(-matrix(P.A()).transpose(), -ones_matrix(n*n,1).column(0), -ones_matrix(2*n+1,1).column(0))
#RD = R.dual()
show(RD)
RD = RD.standard_form()
show(RD)
show(RD.Abcx())

#Sympleks
RD.run_simplex_method()







