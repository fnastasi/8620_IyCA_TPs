close all;
clear all;

%% 
% Parámetros de la simulación en simulink
global Q_ent r_apertura g rad_menor ang Ts

r_apertura = 0.0254; % [m]
%p_apertura = 1; % [%] 
g = 9.8; % [m/s^2]
rad_menor = 0.05; % [m]
ang = pi/3; % [60°]
Q_ent = 0.0035; % [m^3/s]
alt_tank = 1; % [m]
%h_ini = 0.2; %[m]





%% Cálculo de la apertura de la váluvla para linealización alrededor de h = 0.6m

% Tiempo de muestreo
Ts = 1; %[s]
T0 = Ts; % 

h0_array = [0.2, 0.4, 0.6, 0.8]; % arreglo de alturas para simular
N = size(h0_array,2); % cantidad de alturas que se van a simular
t_sim_array = [100, 500, 1500,2500]; % arreglo de tiempo de simulación de simulink
d_p_apertura = 0.05; % porcentaje de apertura.


% dimensiones del sistema a identificar
n = 1;
m = 0;


t_lin_array = zeros(n+m+1,N);
t_dir_array = zeros(n+m+1,N);
t_rec_array = zeros(n+m+1,N);

% Factor de olvido
alpha = 1;

for i = 1:N % i indexa cada simulación al nivel de equilibrio
    h0 = h0_array(i);
    t_sim = t_sim_array(i);
    
    %h0 = 0.6;
    %t_sim = 1500;
    
    
    [p_apertura_lin, A, B, C] = obtener_modelo_lineal(h0);
    
    Hlc = ss(A,B,C,0);
    Hld_zoh = c2d(Hlc,Ts);
    Ad = Hld_zoh.A;
    Bd = Hld_zoh.B;
    Cd = Hld_zoh.C; 
    Dd = Hld_zoh.D;

    out = sim('TP2_tanque_cuadrados_minimos.slx',t_sim);

    
    
    
    % Resultados de la simulación en simulink
    t  = out.salida.time; % tiempo
    N = size(t,1);
    if t ~= t_sim
        display("ATENCIÓN: Tiempo configurado de simulación de simulink es distinto el tiempo obtenido cuando se levantaron los datos de la simulación")
    end
    
    Y = out.salida.data(:,1);
    U = out.entrada.data(:,1);
    
    t_dir = cuad_min_dir(Y,U,n,m);
    [t_rec, P_rec, K_rec] = cuad_min_rec(Y,U,alpha,n,m);
    
    
    t_dir_array(:,i) = t_dir;
    t_rec_array(:,i) = t_rec(:,end);
    t_lin_array(:,i) = [Ad;Bd];
    
    
    
    
    A_dir = t_dir(1);
    B_dir = t_dir(2);
    H_dir = ss(A_dir,B_dir,1,0,Ts);
    
    A_rec = t_rec(1,end);
    B_rec = t_rec(2,end);
    H_rec = ss(A_rec,B_rec,1,0,Ts);
    
    % Calculo de los parámetros de forma directa
    
    % Vector salida del sistema usado en el cálculo de los parámetros
    %Y = out.salida.data(:,1);
    %Y_flip = flip(Y);
    
    % Vector entrada del sistema usado en el cálculo de los parámetros
    %U = out.entrada.data(:,1);
    
    % Matriz PHI usada en el cálculo de los parámetros de forma directa
    %PHI = zeros(k, n+m+1); % inicialización de laa matriz
    %PHI(:,1) = flip( [0 ; Y(1:end-1)]);
    %PHI(:,2) = flip( [0 ;  U(1:end-1)]);
    
    % Cálculos de los parámetros de forma directa
    %param_directo = inv(PHI' * PHI) * PHI * Y_flip;
    
    
    
    
    
    
 
    % Para obtener la respuesta impulsiva a partir de la respuesta al
    % escalón, se realiza la resta entre muestras consecutivas y se divide
    % por la altura del escalón
    %resp_imp_por_esc(2:end) =  (  resp_esc_no_lin(2:end) - resp_esc_no_lin(1:end - 1) ) /  (p_apertura_lin*d_p_apertura);

    % Para obtener la respuesta impulsiva a partir de una entrada de ruido
    % blanco, se calcula la correlación entre la entrada y la salida y se
    % lo divide por la varianza del ruido blanco.
    %resp_imp_por_RB = xcorr(resp_RB_no_lin,RB,'biased');
    %resp_imp_por_RB = resp_imp_por_RB(size(t,1):end)/ ((p_apertura_lin*d_p_apertura)^2);


    % Se grafican las 4 curvas que corresponden al cálculo de la respuesta
    % impulsiva. Se multiplica por 100 para utilizar al centímetro como unidad
    % para el nivel del agua.
    %figure
    %plot(t,resp_imp_ZOH * 100) 
    %hold on
    %plot(t,resp_imp_por_RB * 100)
    %plot(t,resp_imp_no_lin * 100)
    %plot(t,resp_imp_por_esc * 100)
    %grid()
    %xlabel("Tiempo [s]")
    %ylabel("Nivel [cm]")
    %legend("Resp. imp. Linealización", "Resp. imp.", "Resp. imp. mediante escalón","Resp. imp. mediante ruido blanco",'Location','southeast')
    %hold off
end

%%




%p_apertura_lin = Q_ent/(pi*r_apertura^2) / (sqrt(2*g*h0)); % valor de apertura para que la derivada de h sea igual a 0

%%
% En el sistema linealizado 
% Delta_h_dot = A*Delta_h + B*Deslta_Q_ent
% Delta_y = Delta_h



% Caudal de entrada sobre el cual se linealiza
%Q_ent_0 = Q_ent;


% A continuación se calculan los valores del sistema linealizado


%B = (-sqrt(2*g*h0)*(r_apertura^2)) /( (rad_menor + h0/tan(ang))^2);

% Calculo del numerador de A (se ahce en partes para que no quede tan largo)
%A = (- p_apertura_lin*sqrt(g/(2*h0))*(pi*r_apertura)^2)*(rad_menor + h0/tan(ang))^2;

%A = A - 2*pi*(Q_ent_0 - sqrt(2*g*h0)*p_apertura_lin*pi*r_apertura^2) * (rad_menor + h0/tan(ang)) / tan(ang) ;

% Al cálculo anterior lo divido por el denominador de A
%A = A /pi^2 /( (rad_menor + h0/tan(ang))^4);

%C = 1;

%D = 0;

% Definición del modelo en espacio de estados para el sistema linealizado
%Hlc = ss(A,B,C,D);

% Perturbación en la válvula de apertura
%d_p_apertura = 0.05;


%%

% Defino un periodo de muestreo lo suficientemente chico para seguir a la
% dinámica de la planta
%Ts = 1;

% Discretización de la linealización por el método ZOH
%Hld_zoh = c2d(Hlc,Ts );
%A_zoh = Hld_zoh.A;
%B_zoh = Hld_zoh.B;
%C_zoh = Hld_zoh.C; 
%D_zoh = Hld_zoh.D;


% Discretización de la linealización por el método Tustin
%Hld_tustin = c2d(Hlc,Ts,'tustin' );
%A_tustin = Hld_tustin.A;
%B_tustin = Hld_tustin.B;
%C_tustin = Hld_tustin.C; 
%D_tustin = Hld_tustin.D;



