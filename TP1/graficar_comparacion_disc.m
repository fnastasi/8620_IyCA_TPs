
% Gráficos obtenidos a partir de la comparación del modelo del tanque no
% lineal con el modelo linealizado y las discretizaciones con el modelo
% Tustin y ZOH

% Ejecutar este script luego de ejecutar la simulación en Simulink para
% obtener los datos en out

tiempo = out.comp_no_lineal_con_lineal_disc.Time; % Tiempo
data_no_lineal = out.comp_no_lineal_con_lineal_disc.Data(:,1); % Planta no lineal
data_lineal = out.comp_no_lineal_con_lineal_disc.Data(:,2); % Planta linealizada
data_lineal_disc_zoh = out.comp_no_lineal_con_lineal_disc.Data(:,3); %Planta linealizada y discretizada con método ZOH
data_lineal_disc_tustin = out.comp_no_lineal_con_lineal_disc.Data(:,4); %Planta linealizada y discretizada con método Tustin


% Grafico comparando los distintos modelos para un incremento del 5 % de la
% apertura de la válvula
figure(1)
plot(tiempo,data_no_lineal)
hold on
plot(tiempo,data_lineal)
plot(tiempo,data_lineal_disc_zoh)
plot(tiempo,data_lineal_disc_tustin)
grid()
xlabel('Tiempo [s]');
ylabel('Nivel del tanque [m]');
legend('Modelo no lineal', 'Modelo linealizado','Modelo discretizado ZOH', 'Modelo discretizado Tustin');
saveas(gcf,'comp_incr_5_disc.png')
hold off





% Se grafica el mismo resultado que antes pero solamente en una porción de
% tiempo para apreciar ambas discretizaciónes

tiempo_zoom = tiempo(1:700,1);
data_no_lineal_zoom = data_no_lineal(1:700,1);
data_lineal_zoom = data_lineal(1:700,1);
data_lineal_disc_zoh_zoom = data_lineal_disc_zoh(1:700,1);
data_lineal_disc_tustin_zoom = data_lineal_disc_tustin(1:700,1);


figure(2)
plot(tiempo_zoom,data_no_lineal_zoom)
hold on
plot(tiempo_zoom,data_lineal_zoom)
plot(tiempo_zoom,data_lineal_disc_zoh_zoom)
plot(tiempo_zoom,data_lineal_disc_tustin_zoom)
grid()
xlabel('Tiempo [s]');
ylabel('Nivel del tanque [m]');
legend('Modelo no lineal', 'Modelo linealizado', 'Modelo discretizado ZOH','Modelo discretizado Tustin');
saveas(gcf,'comp_incr_5_disc_zoom.png')


