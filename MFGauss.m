function[y]=MFGauss(m,n,s1,s2,x)
%Función de membresía difusa gaussiana. 
%
% ___Inputs___
% *m (escalar): Valor esperado (promedio o centro de la campana) de la primera curva gaussiana. 
% *n (escalar): Valor esperado de la segunda curva gaussiana. 
% *s1 (escalar): Desviación estándar de la primera curva. 
% *s2 (escalar): Desviación estándar de la segunda curva. 
% *x (escalar): Variable lingüística. 
%
% ___Outputs___
% y (escalar): Grado de membresía de x. 

    if(x<m)
        y=exp(-((x-m)/s1)^2); 
        return; 
    end 
    if(x>=m && x<=n)
        y=1; 
        return; 
    end 
    if(x>n)
        y=exp(-((x-n)/s2)^2); 
        return; 
    end 
    y=NaN; 
end 
