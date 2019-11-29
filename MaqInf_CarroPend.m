clc
clear 
MFTrap=@(a,b,c,d, ran)matfun(@(x)MFTrap(a,b,c,d,x ), ran);
MFTri=@(a,b,c, ran)matfun(@(x)MFTrap(a,b,b,c,x ), ran);

paso=0.05; 
xi=-2;
xn=2; 
rangoX=xi:paso:xn; 

yi=-15; 
yn=15; 
rangoY=yi:paso:yn; 

zi=-100; 
zn=100; 
rangoZ=zi:paso:zn; 


%Antecedencias 1 
X1=@(x)MFTrap(-pi/2, -pi/2,-pi/3, -pi/4, x); 
X2=@(x)MFTrap(-5*pi/12, -pi/3,-pi/6, -pi/12, x); 
X3=@(x)MFTrap(-pi/4,-3*pi/12,-pi/48, 0, x);
X4=@(x)MFTrap(-pi/24, 0, 0, pi/24, x);
X5=@(x)MFTrap(0, pi/48, 3*pi/12, pi/4, x);
X6=@(x)MFTrap(pi/12, pi/6, pi/3, (5*pi)/12, x);
X7=@(x)MFTrap(pi/4, pi/3, pi/2, pi/2, x);

Xs=@(x)[X1(x);X2(x); X3(x); X4(x); X5(x); X6(x); X7(x)]; 

%Aqu+i me quedé
 %Antecedencias 2 
 Y1=@(y)MFTrap(-4*pi, -2*pi, -(4*pi)/3, -2*pi/2, y); 
 Y2=@(y)MFTrap(-(10*pi)/6, -(4*pi)/3, -2*pi/3, -2*pi/6, y); 
 Y3=@(y)MFTrap(-2*pi/2, -2*pi/3, -2*pi/6, 0, y); 
 Y4=@(y)MFTrap(-2*pi/6, 0, 0, 2*pi/6, y);
 Y5=@(y)MFTrap(0, 2*pi/6, 2*pi/3, 2*pi/2, y); 
 Y6=@(y)MFTrap(2*pi/6, 2*pi/3, (4*pi)/3, (10*pi)/6, y);
 Y7=@(y)MFTrap(2*pi/2, (4*pi)/3, 2*pi, 4*pi, y);
 Ys=@(y)[Y1(y); Y2(y); Y3(y); Y4(y); Y5(y); Y6(y); Y7(y)];
 

 %Consecuencias 
 Z1=@(z)MFTrap(-160/3,-40,-40,-80/3,z);
 Z2=@(z)MFTrap(-40,-80/3,-80/3,-40/3,z);  
 Z3=@(z)MFTrap(-80/3,-40/3,-40/3,0,z);
 Z4=@(z)MFTrap(-40/3,0,0,40/3,z);
 Z5=@(z)MFTrap(0,40/3,40/3,80/3,z);
 Z6=@(z)MFTrap(40/3,80/3,80/3,40,z);
 Z7=@(z)MFTrap(80/3,40,40,160/3,z);
 
 Zs={Z1(rangoZ), Z2(rangoZ), Z3(rangoZ), Z4(rangoZ), Z5(rangoZ), Z6(rangoZ), Z7(rangoZ)};
 Zsplot=@(z)[Z1(z);Z2(z);Z3(z);Z4(z);Z5(z); Z6(z); Z7(z)];
 vector0=0*rangoZ; 

 %Reglas
 Rs={
     Zs{1},Zs{1},Zs{2},Zs{2}, Zs{3}, Zs{3}, Zs{4};
     Zs{1},Zs{2},Zs{2},Zs{3}, Zs{3}, Zs{4}, Zs{5};
     Zs{2},Zs{2},Zs{3},Zs{3}, Zs{4}, Zs{5}, Zs{5};
     Zs{2},Zs{3},Zs{3},Zs{4}, Zs{5}, Zs{5}, Zs{6};
     Zs{3},Zs{3},Zs{4},Zs{5}, Zs{5}, Zs{6}, Zs{6};
     Zs{3},Zs{4},Zs{5},Zs{5}, Zs{6}, Zs{6}, Zs{7};
     Zs{4},Zs{5},Zs{5},Zs{6}, Zs{6}, Zs{7}, Zs{7};
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
 disp('Ejemplo, Zxy(-1,-0.8)')
 Zxy(-1,-0.8)
