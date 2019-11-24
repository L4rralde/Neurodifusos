MFTrap=@(a,b,c,d, ran)matfun(@(x)MFTrap(a,b,c,d,x ), ran);
MFGauss=@(m,n,s1,s2, ran)matfun(@(x)MFGauss(m,n,s1,s2,x ), ran);

paso=0.1; %Paso de todos los vectores

%X: Primera variable de discurso
xi=-10;
xn=10; 
rangoX=xi:paso:xn;  

%Y: Segunda variable de discurso
yi=-20; 
yn=0; 
rangoY=yi:paso:yn; 

%Z: entrada de los vectores de consecuencias
zi=0; 
zn=20; 
rangoZ=zi:paso:zn; 


%Antecedencias 1 
X1=@(x)MFTrap(-8, -5, -5, 0, x); 
X2=@(x)MFTrap(-6, -3, 2, 2, x); 
X3=@(x)MFTrap(0,2,6,9, x);
Xsplot=@(x)[X1(x);X2(x); X3(x)]; %Esta matriz la hice sólo para graficar las primeras antecedencias

%Antecedencias 2
Y1=@(y)MFTrap(-15, -15, -10, -5, y); 
Y2=@(y)MFTrap(-10, -5, 0, 0, y); 
Ysplot=@(y)[Y1(y); Y2(y)]; %Esta matriz la hice sólo para graficar las segundas antecedencias

%Consecuencias 
Z1=@(z)MFGauss(5,6,1,3,z); 
Z2=@(z)MFGauss(8,10,2,1,z); 
Z3=@(z)MFGauss(12,14,2,2,z);
Z4=@(z)MFGauss(16,18,3,0.5,z);
Zs={Z1(rangoZ), Z2(rangoZ), Z3(rangoZ), Z4(rangoZ)}; %Celda con todas las funciones de consecuencias
Zsplot=@(z)[Z1(z);Z2(z);Z3(z);Z4(z)]; %Para graficar las consecuencias
vector0=0*rangoZ;  %Un vector del tamaño de las funciones de consecuencia, pero sólo con unos
%Reglas
Rs={
    Zs{1},vector0,Zs{2};
    Zs{3},Zs{4},vector0
};
%Esta celda es equivalente a lo siguiente: 
%Si Y1 y X1, entonces salida=Z1
%Si Y1 y X2, entonces salida=0
%Si Y1 y X3, salida=Z2
%Si Y2 y X1, salida=Z3
%Si Y2 y X2, salida=Z4
%Si Y2 y X3, salida=0

Rs=reshape(Rs,1, []);
Salidas=num2cell(zeros(1, length(Rs)));  %Creo mi celda llena de vectores de 0. 
                                         %Estos vectores serán reemplazados según la matriz de reglas. 
[X,Y]=meshgrid(rangoX, rangoY);         %Creo mi espacio de discurso. 
Z=ones(size(X));                        %Inicializo la curva, poniendo todos en 1. 
i=1; 
disp('Espere un momento, le recomendamos borrar todas las variables (clear) para correr más rápido')
for entradaX=rangoX  %Para cualquier punto de la primera variable de discurso
    j=1; 
    for entradaY=rangoY %Para cualquier punto de la segunda variable de discurso
        Xs=[X1(entradaX), X2(entradaX), X3(entradaX)]; %Creo el vector con las membresías de la primera variable
        Ys=[Y1(entradaY), Y2(entradaY)];   %Lo mismo, pero con la segunda.
        supMem=CartProd(Xs, Ys); %Hago todas las combinaciones de ambos vectores en una matriz.  
        supMem=reshape(cellfun(@(x) min(x), supMem), 1, []);    %Le aplico el mínimo a todas las combinaciones
                                                                %De esta forma calculo la intercepción de ambos vectores de membresía. 

        for x=1: length(Rs)
            Salidas{x}=Rs{x}*supMem(x);                         %Aplico las reglas
        end 
        Salida=max(max(max(Salidas{1}, Salidas{2}),max(Salidas{3}, Salidas{4})),  max(Salidas{5}, Salidas{6})); %Obtengo la curva de la salida
        c=MFCentroid(Salida, rangoZ); %Calculo el centroide de esta curva
        Z(j, i)=c; %La guardo en Z, de esta forma se va formando la superficie FIS. 
        j=j+1; 
    end 
    i=i+1; 
end 
disp('Listo')
%Plots
figure(1)
subplot(2,2,1)
plot(rangoX, Xsplot(rangoX))

subplot(2,2,2)
plot(rangoY, Ysplot(rangoY))

subplot(2,2,3)
plot(rangoZ, Zsplot(rangoZ))

figure(2)
mesh(X,Y,Z)

%Función de la máquina de inferencia
disp('El programa regresa la función de la máquina')
Zxy=@(x,y) Z(int16((y-yi)/paso+1),int16((x-xi)/paso+1))
%Zxy es la función de la superficie FIS. En realidad es una matriz con todos los resultados guardados. 
%Como se guarda, puede utilizarse en otros programas, por ejemplo, para controlar el carro péndulo. 
disp('Ejemplo, Zxy(-1,-8)')

Zxy(-1,-8)
