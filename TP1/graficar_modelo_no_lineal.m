% Gráficos obtenidos a partir de la comparación del modelo del tanque no
% lineal con el modelo linealizado

% Ejecutar este script luego de ejecutar la simulación en Simulink para
% obtener los datos en out

tiempo = out.comp_no_lineal_con_lineal.Time;
data_no_lineal = out.comp_no_lineal_con_lineal.Data(:,1);
data_lineal = out.comp_no_lineal_con_lineal.Data(:,2);

dif_porcentual_estado_estacionario = (data_lineal(end) - data_no_lineal(end) ) /  data_no_lineal(end);

plot(tiempo,data_no_lineal)
hold on
plot(tiempo,data_lineal)
grid()
xlabel('Tiempo [s]')
ylabel('Nivel del tanque [m]')
legend('Modelo no lineal', 'Modelo linealizado')
saveas(gcf,'comp_incr_5.png')