function Deltas_PC = BP_Calculo_Deltas(S_PC,Deltas_PC,error,Network_PC,Parameter)
% Calcula error de cada neurona por capas

    % Errors in output layer: deltaL
    Deltas_PC{end} = derivar(S_PC{end}) .* error'; % ' por si hay más de una salida

    % Error in previous layers: deltal
    for L=(Parameter.NumLayer-1):-1:1 % help for (from:by:to)
%         Deltas_PC{L} = derivar(S_PC{L}) .* (Network_PC{L+1} * Deltas_PC{L+1}')'; 
          Deltas_PC{L} = derivar(S_PC{L}) .* (Deltas_PC{L+1} * Network_PC{L+1}'); 
    end
end
