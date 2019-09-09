function Network_PC = BP_Incrementar_Pesos(Network_PC,Deltas_PC,S_PC,Pattern,Parameter)
% Coste respecto a cada peso + actualización de cada peso

    % First hidden layer (la activación de la capa previa es el input)
    incrementos = Parameter.Eta * Pattern' * Deltas_PC{1};
    Network_PC{1} = Network_PC{1} + incrementos;
    
    % Resto de capas
    for L=2:Parameter.NumLayer % L=1 es la primera capa oculta                    
        incrementos = Parameter.Eta * S_PC{L-1}' * Deltas_PC{L}; % costes
        Network_PC{L} = Network_PC{L} + incrementos; % update
    end
    
end

