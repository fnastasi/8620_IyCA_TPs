close all;
clear all;

%% 
% Par�metros de la simulaci�n en simulink

r_apertura = 0.0254; % [m]
p_apertura = 1; % [%] 
g = 9.8; % [m/s^2]
rad_menor = 0.05; % [m]
ang = pi/3; % [60�]
Q_ent = 0.0035; % [m^3/s]
alt_tank = 1; % [m]
h_ini = 0.6; %[m]



%% C�lculo de la apertura de la v�luvla para linealizaci�n alrededor de h = 0.6m

h0 = 0.6; %[m]
p_apertura_lin = Q_ent/(pi*r_apertura^2) / (sqrt(2*g*h0)); % valor de apertura para que la derivada de h sea igual a 0

%%
% En el sistema linealizado 
% Delta_h_dot = A*Delta_h + B*Deslta_Q_ent
% Delta_y = Delta_h



% Caudal de entrada sobre el cual se linealiza
Q_ent_0 = Q_ent;


% A continuaci�n se calculan los valores del sistema linealizado


B = (-sqrt(2*g*h0)*(r_apertura^2)) /( (rad_menor + h0/tan(ang))^2);

% Calculo del numerador de A (se ahce en partes para que no quede tan largo)
A = (- p_apertura_lin*sqrt(g/(2*h0))*(pi*r_apertura)^2)*(rad_menor + h0/tan(ang))^2;

A = A - 2*pi*(Q_ent_0 - sqrt(2*g*h0)*p_apertura_lin*pi*r_apertura^2) * (rad_menor + h0/tan(ang)) / tan(ang) ;

% Al c�lculo anterior lo divido por el denominador de A
A = A /pi^2 /( (rad_menor + h0/tan(ang))^4);

C = 1;

D = 0;

% Definici�n del modelo en espacio de estados para el sistema linealizado
Hlc = ss(A,B,C,D);

% Perturbaci�n en la v�lvula de apertura
d_p_apertura = 0.05;


%%

% Defino un periodo de muestreo lo suficientemente chico para seguir a la
% din�mica de la planta
Ts = 10;

% Discretizaci�n de la linealizaci�n por el m�todo ZOH
Hld_zoh = c2d(Hlc,Ts );
A_zoh = Hld_zoh.A;
B_zoh = Hld_zoh.B;
C_zoh = Hld_zoh.C; 
D_zoh = Hld_zoh.D;


% Discretizaci�n de la linealizaci�n por el m�todo Tustin
Hld_tustin = c2d(Hlc,Ts,'tustin' );
A_tustin = Hld_tustin.A;
B_tustin = Hld_tustin.B;
C_tustin = Hld_tustin.C; 
D_tustin = Hld_tustin.D;



