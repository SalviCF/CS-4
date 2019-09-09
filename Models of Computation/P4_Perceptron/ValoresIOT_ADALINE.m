function [Input,Output,Target] = ValoresIOT_ADALINE(Data, W, i)
% Valores Input i, Output i, Target i para la ADALINA.
% Usamos la funci�n identidad (no signo) para calcular el output.
% As�, adem�s de saber si la neurona se ha equivocado o no,
    % cuantificamos el error.
% El resultado es que la red converge en menos �pocas (de media).
% Para problemas de clasificaci�n, pasamos la salida de la funci�n
    % identidad por la funci�n signo. Pero los c�lculos se siguen
    % haciendo con la funci�n continua (identidad en este caso).

Input = [Data(i, 1:2) -1]; % patr�n de entrada i y el input del bias (siempre -1)
Output = Input * W; % salida de la red para el patr�n de entrada i. 
Target = Data(i, end); % salida objetivo i 

end

