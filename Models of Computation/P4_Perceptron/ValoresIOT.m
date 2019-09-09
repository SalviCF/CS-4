function [Input,Output,Target] = ValoresIOT(Data, W, i)
% Valores Input i, Output i, Target i para el perceptr�n

Input = [Data(i, 1:2) -1]; % patr�n de entrada i y el input del bias (siempre -1)
Output = Signo(Input * W); % salida de la red para el patr�n de entrada i
Target = Data(i, end); % salida objetivo i 

end

