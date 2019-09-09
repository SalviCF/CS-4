function [Input,Output,Target] = ValoresIOT_ADALINE(Data, W, i)
% Valores Input i, Output i, Target i para la ADALINA.
% Usamos la función identidad (no signo) para calcular el output.
% Así, además de saber si la neurona se ha equivocado o no,
    % cuantificamos el error.
% El resultado es que la red converge en menos épocas (de media).
% Para problemas de clasificación, pasamos la salida de la función
    % identidad por la función signo. Pero los cálculos se siguen
    % haciendo con la función continua (identidad en este caso).

Input = [Data(i, 1:2) -1]; % patrón de entrada i y el input del bias (siempre -1)
Output = Input * W; % salida de la red para el patrón de entrada i. 
Target = Data(i, end); % salida objetivo i 

end

