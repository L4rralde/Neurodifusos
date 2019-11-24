function [matriz]=CartProd(X, Y)
    matriz=num2cell(ones(length(Y), length(X))); 
    for i=1:length(X)
        for j=1:length(Y)
            matriz{j,i}=[X(i),Y(j)]; 
        end
    end
end 
