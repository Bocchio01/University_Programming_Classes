function [xi, x_iter] = bisection(f, a, b, max_iter)
  %BISECTION Trova la radice di f(x) = 0 nell'intervallo [a,b]
  %   usando il metodo di bisezione. I limiti dell'intervallo devono essere tali che
  %   f(a)*f(b)<0.
  %
  %   [xi, x_iter] = BISECTION(f, a, b, max_iter)
  %
  %   Inputs  : f          = handle function f(x)
  %             a          = estremo sinistro
  %             b          = estremo destro
  %             max_iter   = numero di iterazioni
  %   Output  : 
  %			xi = radice approssimata
  %			x_iter     = vettore delle approssimazioni a ogni step

 
  for (iter = 1:max_iter)
    x_iter(iter) = a + (b-a)/2;
    f_iter(iter) = f(x_iter(iter));
    
    if ( f(b)*f_iter(iter) < 0 )
      a = x_iter(iter);
    elseif ( f(a)*f_iter(iter) < 0 )
      b = x_iter(iter);
    else % f(x) = 0
      break;
    end
  end
  
  xi = x_iter(end);

end
