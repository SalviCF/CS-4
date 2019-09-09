function W = ModificarPesos(W,Ys,Patron,LR)

% It is updated only the synaptic weights of the winning neuron
% w_r(k+1) = w_r(k) + LR(k)[x(k) - w_r(k)]

incremento = Ys .* ( LR*(Patron'-W) );

W = W + incremento;

end

