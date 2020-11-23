function p = cuad_min_dir(Y,U,n,m)
% Y: salida
% U: entrada

%p: parámetros del modelo

N = size(Y,1);

% Calculo de los parámetros del modelo forma directa
    
% Vector salida del sistema usado en el cálculo de los parámetros
Y_flip = flip(Y);

% Matriz PHI usada en el cálculo de los parámetros de forma directa
PHI = zeros(N, n+m+1); % inicialización de la matriz
PHI(:,1) = flip( [0; Y(1:end-1)] );
PHI(:,2) = flip( [0; U(1:end-1)] );

% Cálculos de los parámetros de forma directa
%p = inv(PHI' * PHI) * PHI' * Y_flip;
p = (PHI' * PHI) \ PHI' * Y_flip;

end