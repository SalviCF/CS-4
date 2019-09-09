function all_correct = CheckPatterns(Data, W)
% Da true si todas las salidas objetivo son iguales a las salidas de la red.

z = Data(:,end); % salidas objetivo

patterns = Data(:,1:2); % inputs sin el bias

w_bias = W(3); % peso del bias (su input es siempre -1)

y = Signo(patterns*W(1:2) - w_bias); % suma ponderada: salidas dadas por la red

all_correct = all(z == y); % si elemento a elemento son todos iguales, devuelve true
end

