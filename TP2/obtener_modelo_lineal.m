function [p_apertura_lin,A,B,C] = obtener_modelo_lineal(h0)
    % Esta funci�n obtiene los valores de A B y C del modelo linelizado
    % seg�n el nivel sobre el que se quiere linealizar h0
    % Tambi�n calcula el valor del porcentaje de apertura de la v�lvula
    % sobre la cual se linealiza.

    global Q_ent r_apertura g rad_menor ang;
    
    p_apertura_lin = Q_ent/(pi*r_apertura^2) / (sqrt(2*g*h0)); % valor de apertura para que la derivada de h sea igual a 0
    
    % A continuaci�n se calculan los valores del sistema linealizado
    
    B = (-sqrt(2*g*h0)*(r_apertura^2)) /( (rad_menor + h0/tan(ang))^2);

    % Calculo del numerador de A (se ahce en partes para que no quede tan largo)
    A = (- p_apertura_lin*sqrt(g/(2*h0))*(pi*r_apertura)^2)*(rad_menor + h0/tan(ang))^2;

    A = A - 2*pi*(Q_ent - sqrt(2*g*h0)*p_apertura_lin*pi*r_apertura^2) * (rad_menor + h0/tan(ang)) / tan(ang) ;

    % Al c�lculo anterior lo divido por el denominador de A
    A = A /pi^2 /( (rad_menor + h0/tan(ang))^4);

    C = 1;

end