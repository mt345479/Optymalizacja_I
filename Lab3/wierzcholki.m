%===================================================

function wierzcholki(A, b, F)
	[m, n] = size(A);
	MAX =0;
	M = NpoK(A, b);
	
    for k = M
		B = [A(:,k)];
		if (det(B) != 0)
			w = B \ b;
			v = zeros(n,1);
			v(k) = w;
			if (MAX<F(v) && v(1:n)>=0)
				MAX=F(v);
				uklad_lewa_str = A
				uklad_prawa_str = b
				maksymalny_wierzcholek = B
				maksymalny_wektor_ = v
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

function B = dopisz(A,v)
    if(A == zeros(size(v)) )
        B = v;
    else
        B = zeros(size(A)(1), size(A)(2)+1);
        B(:, 1 : size(A)(2) ) = A;
        B(:, size(A)(2)+1 ) = v;
    endif
endfunction