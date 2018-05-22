e=[4,6,1,2,5,1,2,3,1,6,5,4,5,4,1,2,1,6,3,2,6,5,2,1,2,3,1,6,3,4,1,2,3,4,1,6,4,1,5,3,5,4,6,2,5,6,4,1,5,6,2,3,6,2,5,4,3,4,2,5,5,3,1,6];
d=[4,1,2,5,1,6,5,4,1,2,3,4,5,3,4,2]

p = MixedIntegerLinearProgram()
x = p.new_variable(binary=True)

n = 4

p.set_objective(sum(x[i] for i in range(16*n*n))) #funkcja celu

# MACIERZ PERMUTACJI I OBROTÓW KLOCKÓW

# stałe równoległe do diagonali w każdym z 16 bloków 4x4
for i in range(n):
    for j in range(n):
        p.add_constraint(x[4*i+16*n*j+2] == x[4*i+16*n*j+4*n+3])
        p.add_constraint(x[4*i+16*n*j+1] == x[4*i+16*n*j+4*n+2] == x[4*i+16*n*j+8*n+3])
        p.add_constraint(x[4*i+16*n*j+0] == x[4*i+16*n*j+4*n+1] == x[4*i+16*n*j+8*n+2] == x[4*i+16*n*j+12*n+3])
        p.add_constraint(x[4*i+16*n*j+4*n] == x[4*i+16*n*j+8*n+1] == x[4*i+16*n*j+12*n+2])
        p.add_constraint(x[4*i+16*n*j+8*n] == x[4*i+16*n*j+12*n+1])

#każdy blok ma stałe sumy w wierszach i kolumnach (albo w każdym/-ej 0, albo 1); wystarczy zbadać same wiersze
for i in range(n):
    for j in range(n):
        p.add_constraint( (sum((x[4*i+16*n*j+k+ 0])for k in range(4))) == (sum((x[4*i+16*n*j+k+ 4*n])for k in range(4))) == (sum((x[4*i+16*n*j+k+ 8*n])for k in range(4))) == (sum((x[4*i+16*n*j+k+ 12*n])for k in range(4))) )

for i in range(4*n): # cała macierz jest permutacją
    p.add_constraint(sum(x[j+4*n*i] for j in range(4*n)) == 1) # jednka w każdym wierszu
    p.add_constraint(sum(x[j*4*n+i] for j in range(4*n)) == 1) # jednka w każdej kolumnie

for i in range(n): # cała macierz jest permutacją bloków
    p.add_constraint(sum(sum(x[k + 4*n*j + 16*n*i] for k in range(4*n)) for j in range(4)) == 4) # jednka w każdym wierszu
    p.add_constraint(sum(sum(x[j + 4*n*k + 4*i] for k in range(4*n)) for j in range(4)) == 4) # jednka w każdej kolumnie

    
# kolory ścian przyległych muszą być sobie równe
for i in range(sqrt(n)-1):
    for j in range(sqrt(n)-1):
        p.add_constraint((sum(d[k]*x[1 + 4*j + 4*sqrt(n)*i + 4*n*k] for k in range(4*n))) == (sum(d[k]*x[3 + 4*(j+1) + 4*sqrt(n)*i + 4*n*k] for k in range(4*n))))
        p.add_constraint((sum(d[k]*x[2 + 4*j + 4*sqrt(n)*i + 4*n*k] for k in range(4*n))) == (sum(d[k]*x[0 + 4*j + 4*sqrt(n)*(i+1) + 4*n*k] for k in range(4*n))))

p.add_constraint( (sum(d[k]*x[1 + 4*(sqrt(n)-2) + 4*sqrt(n)*(sqrt(n)-1) + 4*n*k] for k in range(4*n))) == (sum(d[k]*x[3 + 4*(sqrt(n)-1) + 4*sqrt(n)*(sqrt(n)-1) + 4*n*k] for k in range(4*n))) )
p.add_constraint( (sum(d[k]*x[2 + 4*(sqrt(n)-1) + 4*sqrt(n)*(sqrt(n)-2) + 4*n*k] for k in range(4*n))) == (sum(d[k]*x[0 + 4*(sqrt(n)-1) + 4*sqrt(n)*(sqrt(n)-1) + 4*n*k] for k in range(4*n))) )       

show(p.solve());
for i, v in p.get_values(x).iteritems():
    if(v == 1): print('x_%s = %s' % (i, int(round(v))))
p.show();
