<<<<<<< HEAD
﻿%===================================================

function wierzcholki_(A, b)
	[m, n] = size(A)
	MAX =0;
	M = NpoK(A, b)
	
    for k = M
		B = [A(:,k)];
		if (det(B) != 0)
			w = B \ b;
			v = zeros(n,1);
			v(k) = w;
			F = v(1) + v(2);
			if (MAX<F && v(1:n)>=0)
				MAX=F;
				B
				v
				x1 = v(1)
				x2 = v(2)
				F_max = MAX
			endif
		endif
	end
endfunction

%===================================================

function M = NpoK(A, b)
global X
  [k,n] = size(A);
  x = zeros(k,1);
  X = zeros(size(x));
  t = 0;
  generuj(k, t, n, x, A, b);
  M=X;
endfunction

%===================================================

function generuj(k, t, n, x, A, b)
global X
  MAX=0;
  ros=1;
  for a = 1 : k-1
    if (x(a)>=x(a+1))
      ros=0;
    endif
  end
  
	if(t==k)
    if(ros)
     X = dopisz(X,x);
    endif
  else
    for j = 1 : n
      x(t+1) = j;
      generuj(k, t+1, n, x, A, b);
    end
  endif
endfunction

%===================================================
=======
# SYMPLEKS

Program rozwiązuje problem dodatkowej instancji metody sympleks szukającej wierzchołka początkowego pierwotnego problemu.

Aby go uruchomić, należy wprowadzić dany problem w postaci standardowej.

Działanie programu na konkretnym przykładzie zaczerpniętym ze strony:
  http://mst.mimuw.edu.pl/lecture.php?lecture=op1&part=Ch6
można zobaczyć na mojej chmurze SageMath:
  https://cloud.sagemath.com/projects/ac1be6fd-371e-444c-94f2-6bb5ee05dddd/files/Sympleks2.sagews
>>>>>>> f400d75d070e9b5a5ad4688463bfb31f9841a3d2
