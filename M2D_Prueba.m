MFTrap=@(a,b,c,d, ran)matfun(@(x)MFTrap(a,b,c,d,x ), ran);
MFGauss=@(m,n,s1,s2, ran)matfun(@(x)MFGauss(m,n,s1,s2,x ), ran);

paso=0.1; 
xi=-10;
xn=10; 
rangoX=xi:paso:xn; 

yi=-20; 
yn=0; 
rangoY=yi:paso:yn; 

zi=0; 
zn=20; 
rangoZ=zi:paso:zn; 


%Antecedencias 1 
X1=@(x)MFTrap(-8, -5, -5, 0, x); 
X2=@(x)MFTrap(-6, -3, 2, 2, x); 
X3=@(x)MFTrap(0,2,6,9, x);
Xsplot=@(x)[X1(x);X2(x); X3(x)]; 

%Antecedencias 2
Y1=@(y)MFTrap(-15, -15, -10, -5, y); 
Y2=@(y)MFTrap(-10, -5, 0, 0, y); 
Ysplot=@(y)[Y1(y); Y2(y)]; 

%Consecuencias 
Z1=@(z)MFGauss(5,6,1,3,z); 
Z2=@(z)MFGauss(8,10,2,1,z); 
Z3=@(z)MFGauss(12,14,2,2,z);
Z4=@(z)MFGauss(16,18,3,0.5,z);
Zs={Z1(rangoZ), Z2(rangoZ), Z3(rangoZ), Z4(rangoZ)};
Zsplot=@(z)[Z1(z);Z2(z);Z3(z);Z4(z)];
vector0=0*rangoZ;  
%Reglas
Rs={
    Zs{1},vector0,Zs{2};
    Zs{3},Zs{4},vector0
};
Rs=reshape(Rs,1, []);
Salidas=num2cell(zeros(1, length(Rs))); 
[X,Y]=meshgrid(rangoX, rangoY); 
Z=ones(size(X)); 
i=1; 
disp('Espere un momento, le recomendamos borrar todas las variables (clear) para correr más rápido')
for entradaX=rangoX
    j=1; 
    for entradaY=rangoY
        Xs=[X1(entradaX), X2(entradaX), X3(entradaX)]; 
        Ys=[Y1(entradaY), Y2(entradaY)];
        supMem=CartProd(Xs, Ys); %Nueva función que definí
        supMem=reshape(cellfun(@(x) min(x), supMem), 1, []);

        for x=1: length(Rs)
            Salidas{x}=Rs{x}*supMem(x); 
        end 
        Salida=max(max(max(Salidas{1}, Salidas{2}),max(Salidas{3}, Salidas{4})),  max(Salidas{5}, Salidas{6}));
        c=MFCentroid(Salida, rangoZ); 
        Z(j, i)=c; 
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
disp('Ejemplo, Zxy(-1,-8)')
Zxy(-1,-8)
