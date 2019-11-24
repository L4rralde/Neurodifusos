function[y]=MFTrap(a,b,c,d,x)
%Función de membresía difusa trapezoidal. 
%
% ___Inputs___
% *a (escalar): Primer vértice del Trapecio. 
% *b (escalar): Segundo vértice. 
% *c (escalar): Tercer vértice. 
% *d (escalar): Cuarto vértice. 
% *x (escalar): Variable lingüística. 
%
% ___Outputs___
% y (escalar): Grado de membresía de x. 
    if(x<a)
        y=0; 
        return; 
    end 
    if(x>=a && x<b)
        y=(x-a)/(b-a); 
        return; 
    end 
    if(x>=b && x<=c)
        y=1; 
        return; 
    end 
    if(x>c && x<d)
        y=(d-x)/(d-c); 
        return; 
    end 
    if(x>=d)
        y=0; 
        return; 
    end 
    y=NaN; 
end 
