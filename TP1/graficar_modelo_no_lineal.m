% Gráficos obtenidos a partir de la comparación del modelo del tanque no
% lineal con el modelo linealizado

% Ejecutar este script luego de ejecutar la simulación en Simulink para
% obtener los datos en out

tiempo = out.simout.Time;
data_no_lineal = out.simout.Data(:,1);

figure(1)
plot(tiempo,data_no_lineal)
grid()
xlabel('Tiempo [s]')
ylabel('Nivel del tanque [m]')
legend('Modelo no lineal')
%saveas(gcf,'modelo_no_lineal.png')