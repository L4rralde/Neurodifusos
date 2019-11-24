function [Y]=matfun(func, X)
% Función que mapea una matriz completa con una fucnión. 
%
% Inputs
% func (función): Función con la que se mapeará la matriz.  
% X (matriz): Matriz a mapear (un escalar es una matriz de 1x1x1, un vector es una matriz de una fila).
%
% Outputs
% Y (matriz): Matriz mapeada. 
    Y=ones(size(X));
    index=1;
    for columna=X
        Y(:,index)=arrayfun(@(p) func(p), columna);
        index=index+1;
    end 
end
