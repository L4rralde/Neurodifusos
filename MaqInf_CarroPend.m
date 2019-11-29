% PENDULO CARRO [CONTROLAR CON EL SISTEMA FIS (A VER SI SALE CHIDO PUES)]
%clear all;
%close all;
% PARAMETROS DE SIMULACION

TMAX = 20;             % TIEMPO MAXIMO DE SIMULACION (Cambialo si quieres, no menos de 10)
Delta_t = 0.01;        % PASO DE INTEGRACION. (Dejalo así)

% PARAMETROS DE ANIMACION
Wc = 0.4;  % DAS WAGENBREITE (EL ANCHO DEL CARRO PUES)
Hc = 0.2;  % ALTO DEL CARRO (NO ME LO SE EN ALEMÁN xD)
Decimation = 1; % VELOCIDAD DE LA ANIMACION... (Si no te gusta el 2, ponle 5 o 10 a ver que te parece...jejeje)

% PARAMETROS DEL SISTEMA
M = 0.5;     % MASA DEL CARRO (modificar si quieres)
m = 1;       % MASA DEL PENDULO (también este valor)
l = 0.5;     % LONGITUD DEL PENDULO (y este)
bx = 0.5;    % FRICCION VISCOSA ENTRE EL CARRO Y EL SUELO (y este también)
ba = 0.01;   % FRICCION VISCOSA EN LA ARTICULACION DEL PENDULO (y este también)
g = 9.81;    % L'ACCELERAZIONE DELLA GRAVITTÀ ATTORNO DI TERRA (A WEB.COM)
             % (No modificar g... o te repruebo...)

% VARIABLES DINAMICAS
Xn = 0;  % x(t) actual
Xp = 0;  % x pasada
Xf = 0;  % x futura

% TU PONLE UN VALOR CHICO A LA CONDICION INICIAL (Es'cir e.g. THn = 0.2 y THp = 0.2)
% LE VAS A PONER UN VALOR CHICO PORQUE TU NO VAS A HACER EL SWING UP (O SI???)

THn = -0.4; % \theta(t) actual + condicion inicial = \pi radianes
THp = -0.4; % \theta(t-Delta_t) + condicion inicial = \pi radianes
THf = 0;  % \theta futura
dTH=(THn-THp)/Delta_t; 

Fn = 0;  % Fuerza de CONTROL (RESULTADO DE TU SUPERFICIE DEL FIS [EN TU CASO])



i=1; j=1; % ESTOS INDICES SI SE REQUIEREN. . . NO LOS CAMBIES !!!
for t=0:Delta_t:TMAX
    % INSERTAR LEY DE CONTROL AQUI *****
      
      
      % Fn ES LA FUERZA DE CONTROL
      Fn = 5*Zxy(THn, dTH)
      %Fn=10;
    % INSERTAR LEY DE CONTROL AQUI ******
    
    
    % ESTA ES LA SIMULACION DINAMICA (NO MODIFICAR)...
    Mq = [M+m, m*l*cos(THn);...
          m*l*cos(THn), m*(l^2)];
    CGq = [Fn+(m*l/Delta_t^2)*((THn-THp)^2)*sin(THn)-(bx/Delta_t)*(Xn-Xp);...
           m*g*l*sin(THn)-(ba/Delta_t)*(THn-THp)];
    Qn = [Xn; THn];
    Qp = [Xp; THp];
    Qf = (Delta_t^2)*(Mq\CGq)+2*Qn-Qp;
    
    Xf = Qf(1); THf =Qf(2);
    
    % ANIMACION Y VARIABLES DE GRAFICACION ******* (NO MODIFICAR MUCHO)
    if i == j*Decimation
        ROT =[cos(pi/2-THn), sin(pi/2-THn);...
              sin(pi/2-THn), cos(pi/2-THn)];
        PENDULO_DEF = [l; 0];
        PENDULO = ROT*PENDULO_DEF;
        X_CARRO = [Xn-Wc/2, Xn+Wc/2, Xn+Wc/2, Xn-Wc/2];
        Y_CARRO = [0, 0, Hc, Hc];
        
        figure(3);
        fill(X_CARRO,Y_CARRO,'r'); hold on;
        plot(Xn,Hc,'k+',[Xn,Xn+PENDULO(1)], [Hc,Hc+PENDULO(2)],'k', Xn+PENDULO(1),Hc+PENDULO(2),'ko','LineWidth',3);
        hold off;
        
        axis([-2+Xn, 2+Xn, -1.5, 2.5]);
        grid on;  
        getframe(gcf);
        
        X_cart(j) = Xn;
        TH_ang(j) = THn;
        Tiempo(j) = t;
        
        j=j+1;

    end    
    % RECURSION *****
    
    Xp = Xn; Xn = Xf;      % NO MODIFICAR ESTA
    THp = THn;
    THn = THf % NO MODIFICAR ESTA TAMPOCO
    dTH=(THn-THp)/Delta_t
    i=i+1;                % ESTA NO LA BORRES!!!
end
figure(2)
subplot (2,1,1); 
plot(Tiempo, X_cart,'b'); grid on;
xlabel('Tiempo [s]'); ylabel('Posición x(t) [m]'); title('Carro');

subplot(2,1,2); 
plot(Tiempo,TH_ang,'r'); grid on;
xlabel('Tiempo [s]'); ylabel('Ángulo \theta(t) [rad/d]'); title('Pendulo');
