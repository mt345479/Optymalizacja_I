e=[4,6,1,2,5,1,2,3,1,6,5,4,5,4,1,2,1,6,3,2,6,5,2,1,2,3,1,6,3,4,1,2,3,4,1,6,4,1,5,3,5,4,6,2,5,6,4,1,5,6,2,3,6,2,5,4,3,4,2,5,5,3,1,6];
d=[4,1,2,5,1,6,5,4,1,2,3,4,5,3,4,2]

p = MixedIntegerLinearProgram()
x = p.new_variable(binary=True)

n = 16

p.set_objective(sum(x[i] for i in range(n*n))) #funkcja celu

# MACIERZ PERMUTACJI I OBROTÓW KLOCKÓW

# stałe równoległe do diagonali w każdym z 16 bloków 4x4
for i in range(4):
    for j in range(4):
        p.add_constraint(x[4*i+64*j+2] == x[4*i+64*j+19])
        p.add_constraint(x[4*i+64*j+1] == x[4*i+64*j+18] == x[4*i+64*j+35])
        p.add_constraint(x[4*i+64*j+0] == x[4*i+64*j+17] == x[4*i+64*j+34] == x[4*i+64*j+51])
        p.add_constraint(x[4*i+64*j+16] == x[4*i+64*j+33] == x[4*i+64*j+50])
        p.add_constraint(x[4*i+64*j+32] == x[4*i+64*j+49])
# każdy blok jest permutacją
#for i in range(4): 
#    for j in range(16):
#        p.add_constraint(x[4*i+16*j+0]+x[4*i+16*j+1]+x[4*i+16*j+2]+x[4*i+16*j+3] ==1) # jednka w każdym wierszu danego bloku
#        p.add_constraint(x[64*i+j+0]+x[64*i+j+16]+x[64*i+j+32]+x[64*i+j+48] ==1) # jednka w każdej kolumnie danego bloku

for i in range(16): # cała macierz jest permutacją
    p.add_constraint(sum(x[j+16*i] for j in range(16)) ==1) # jednka w każdym wierszu
    p.add_constraint(sum(x[j*16+i] for j in range(16)) ==1) # jednka w każdej kolumnie

for i in range(4): # cała macierz jest permutacją bloków
    p.add_constraint(sum(sum(x[k + 16*j + 64*i] for k in range(16)) for j in range(4)) ==4) # jednka w każdym wierszu
    p.add_constraint(sum(sum(x[j + 16*k + 4*i] for k in range(16)) for j in range(4)) ==4) # jednka w każdej kolumnie

p.add_constraint((sum(d[j]*x[1 + 16*j] for j in range(16))) == (sum(d[j]*x[7 + 16*j] for j in range(16))))
p.add_constraint((sum(d[j]*x[6 + 16*j] for j in range(16))) == (sum(d[j]*x[12 + 16*j] for j in range(16))))
p.add_constraint((sum(d[j]*x[9 + 16*j] for j in range(16))) == (sum(d[j]*x[15 + 16*j] for j in range(16))))
p.add_constraint((sum(d[j]*x[2 + 16*j] for j in range(16))) == (sum(d[j]*x[8 + 16*j] for j in range(16))))

show(p.solve()); p.get_values(x); p.show()
