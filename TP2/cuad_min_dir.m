function p = cuad_min_dir(Y,U,n,m)
% Y: salida
% U: entrada

%p: par�metros del modelo

N = size(Y,1);

% Calculo de los par�metros del modelo forma directa
    
% Vector salida del sistema usado en el c�lculo de los par�metros
Y_flip = flip(Y);

% Matriz PHI usada en el c�lculo de los par�metros de forma directa
PHI = zeros(N, n+m+1); % inicializaci�n de la matriz
PHI(:,1) = flip( [0; Y(1:end-1)] );
PHI(:,2) = flip( [0; U(1:end-1)] );

% C�lculos de los par�metros de forma directa
%p = inv(PHI' * PHI) * PHI' * Y_flip;
p = (PHI' * PHI) \ PHI' * Y_flip;

end