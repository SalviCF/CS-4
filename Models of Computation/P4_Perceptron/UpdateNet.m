function W_new = UpdateNet(W,LR,Output,Target,Input)
% Aplica la regla de aprendizaje del perceptrón
% w_new = w + delta_w
% delta = LR * (z - y) * x

delta_W = LR * (Target - Output) * Input; 
W_new = W + delta_W';

end

