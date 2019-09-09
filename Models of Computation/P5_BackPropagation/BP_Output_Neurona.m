function [S_PC,h_PC] = BP_Output_Neurona(Network_PC,h_PC,S_PC, Pattern, Parameter)
% Forward propagation.
% Debo pasar por todas las capas hacia delante y calcular: 
    % h_PC: potencial sináptico de cada neurona (organizado Por Capas).
    % S_PC: salida de cada neurona (organizado Por Capas).
% w_ij = weight from neuron i of layer l to neuron j in layer l+1

    x = Pattern;

    for L = 1:Parameter.NumLayer        % L=1 es la primera capa oculta
        w = Network_PC{L};              % pesos que van a la capa L
        h_PC{L} = x*w;                  % potenciales capa L
        S_PC{L} = Sigmoide(h_PC{L});    % salidas capa L
        x = S_PC{L};                    % input(L+1)=output(L)
    end

end

