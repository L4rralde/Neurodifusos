function[c]=MFCentroid(mf, rango)
%Función que obtiene la abscisa del centroide de la área debajo de una
%curva. 
%
%Inputs
%vector y curva deben ser del mismo tamaño. 
%mf (vector): Curva de interés. 
%rango (vector): Rango de la curva. 
%
%Outputs
%c (escalar): Abscisa del centroide. 
    delta=rango(2)-rango(1);
    dec=ceil(log10(1/delta)); 
    if (sum(mf)==0)
        c=(rango(1)+rango(end))/2; 
    else 
        c=round(sum(rango.*mf)/sum(mf), dec);
    end
end 
