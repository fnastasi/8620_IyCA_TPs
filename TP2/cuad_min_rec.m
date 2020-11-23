function [t_array, P_array, K_array] = cuad_min_rec(Y,U,alpha,n,m)
% y_full: salida
% u_full: entrada
% alpha: factor de olvido


% t: parametros
% P: Matriz P
% K: Ganancia 


% Calculo de los par�metros del modelo forma recursiva

N = size(Y,1);

% Arreglos para guardar los valores del c�lculo recursivo
t_array = zeros(n+m+1,N);
P_array = zeros(n+m+1,n+m+1,N);
K_array = zeros(n+m+1,N);

% Inicializaci�n:  Condici�n inicial de tita, P

% Se comienza en un valor de tiempo k_ini mayor al maximo de n, m+1 para
% evitar que en matlab se indexe en un n�mero negativo  ( dado que en alg�n
% momento se indexa en la posici�n k -n y k-m-1 y para valores peque�os de
% k, puede resultar en un n�mero negativo
k_ini = max(n,m+1);
k_ini = k_ini + 3;      % Al k_ini se le suma algunos tiempos de muestreo que es el tiempo en el que  se "prende" el escal�n de la entrada  
                        % Esto se hace para evitar que el vector inicial x
                        % sea [0;0] y no exista P


% Se inicia el primer valor de la matriz P y los pa�metros t. Para ello se
% utilizan las primeras muestras de la salida y la entrada de la misma
% forma que se realiz� en el m�todo directo, excepto que ahora solo se
% utilizan unas pocas muestras para el valor inicial De esta forma se
% reduce el costo computacional

PHI_ini = zeros(k_ini, n+m+1); % inicializaci�n de la matriz
PHI_ini(:,1) = flip( [0; Y(1:k_ini-1)] );
PHI_ini(:,2) = flip( [0; U(1:k_ini-1)] );

% Observar que esta es la forma directa de calcular los par�metros P y t
P =  inv(PHI_ini' * PHI_ini);
t = P*PHI_ini' * flip(Y(1:k_ini)); 


% Se realiza la recursi�n  a partir del tiempo siguiente a k_ini
for k = k_ini+1:N
    
    % Se guarda el valor actual de P en el arreglo
    P_array(:,:,k)  =  P;
    
    
    % Se calcula el vector X para el tiempo k
    y = flip( Y(k-n:k-1));
    u = flip( U(k-m-1:k-1));
    x = [y;u];
    
    % Se calculan los par�metros de forma recursiva
    K = P*x /( alpha + x' * P *x);
    t = t + K*( Y(k) - x' * t);
    
    % Se calcula el siguiente valor de P
    P = (P - K * x' * P )/alpha;
    
    
    % Los valores obtenidos se guardan un el arreglo
    t_array(:,k) = t;
    K_array(:,k) = K;
    
end