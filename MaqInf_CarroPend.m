MFTrap=@(a,b,c,d, ran)matfun(@(x)MFTrap(a,b,c,d,x ), ran);
MFTri=@(a,b,c, ran)matfun(@(x)MFTrap(a,b,b,c,x ), ran);

paso=0.05; 
xi=-10;
xn=10; 
rangoX=xi:paso:xn; 

yi=-6; 
yn=6; 
rangoY=yi:paso:yn; 

zi=-30; 
zn=30; 
rangoZ=zi:paso:zn; 


%Antecedencias 1 
X1=@(x)MFTrap(-10, -10,-7, -3, x); 
X2=@(x)MFTri(-4, -2, 0, x); 
X3=@(x)MFTri(-0.5,0,0.5, x);
X4=@(x)MFTri(0, 2, 4, x);
X5=@(x)MFTrap(3, 7, 10,10, x); 
Xs=@(x)[X1(x);X2(x); X3(x); X4(x); X5(x)]; 


 %Antecedencias 2
 Y1=@(y)MFTrap(-4, -4, -2.5, -1, y);
 Y2=@(y)MFTri(-1.5, -0.75, 0, y);
 Y3=@(y)MFTri(-0.3, 0, 0.3, y);
 Y4=@(y)MFTri(0, 0.75, 1.5, y);
 Y5=@(y)MFTrap(1, 2.5, 4.0, 4.0, y);
 Ys=@(y)[Y1(y); Y2(y); Y3(y); Y4(y); Y5(y)];
 

 %Consecuencias 
 Z1=@(z)MFTri(-27,-18,-9,z); 
 Z2=@(z)MFTri(-18,-12,-6,z); 
 Z3=@(z)MFTri(-14,-10,0,z);
 Z4=@(z)MFTri(-2,0, 2,z);
 Z5=@(z)MFTri(0,10,14,z);
 Z6=@(z)MFTri(6,12,18,z); 
 Z7=@(z)MFTri(9,18,27,z); 
 
 Zs={Z1(rangoZ), Z2(rangoZ), Z3(rangoZ), Z4(rangoZ), Z5(rangoZ), Z6(rangoZ), Z7(rangoZ)};
 Zsplot=@(z)[Z1(z);Z2(z);Z3(z);Z4(z);Z5(z); Z6(z); Z7(z)];
 vector0=0*rangoZ; 

 
 %Reglas
 Rs={
     Zs{1},Zs{1},Zs{2},Zs{3}, Zs{4};
     Zs{1},Zs{2},Zs{3},Zs{4}, Zs{5};
     Zs{2},Zs{3},Zs{4},Zs{5}, Zs{6};
     Zs{3},Zs{4},Zs{5},Zs{6}, Zs{7};
     Zs{4},Zs{5},Zs{6},Zs{7}, Zs{7};
 };
 Rs=reshape(Rs,1, []);
 [X,Y]=meshgrid(rangoX, rangoY); 
 Z=ones(size(X)); 
 i=1; 
 disp('Espere un momento, le recomendamos borrar todas las variables (clear) para correr más rápido')
 for entradaX=rangoX
     j=1; 
     for entradaY=rangoY
         supMem=CartProd(Xs(entradaX), Ys(entradaY)); %Nueva función que definí
         supMem=reshape(cellfun(@(x) min(x), supMem), 1, []);
         Salida=zeros(1,length(Rs{1}));
         for x=1: length(Rs)
             Salida=max(Salida,Rs{x}*supMem(x)); 
         end 
%         Salida=max(max(max(Salidas{1}, Salidas{2}),max(Salidas{3}, Salidas{4})),  max(Salidas{5}, Salidas{6}));
         c=MFCentroid(Salida, rangoZ); 
         Z(j, i)=c; 
         j=j+1; 
     end 
     i=i+1
 end 
 disp('Listo')
 %Plots
 figure(1)
 subplot(2,2,1)
 plot(rangoX, Xs(rangoX))
 
 subplot(2,2,2)
 plot(rangoY, Ys(rangoY))
 
 subplot(2,2,3)
 plot(rangoZ, Zsplot(rangoZ))
 
 figure(2)
 mesh(X,Y,Z)
 
 %Función de la máquina de inferencia
 disp('El programa regresa la función de la máquina')
 Zxy=@(x,y) Z(int16((y-yi)/paso+1),int16((x-xi)/paso+1))
 disp('Ejemplo, Zxy(-1,-8)')
 Zxy(-1,-0.8)
        
