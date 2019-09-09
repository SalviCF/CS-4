function Ys = CalculoYs(Hs)

% y_i = 1 if h_i = max_k{h_1, h_2, ... , h_m}
%       0 otherwise

% https://es.mathworks.com/help/matlab/ref/max.html#bubhhu5-1-dim
% https://stackoverflow.com/questions/2651267/why-is-sumx-1-the-sum-of-the-columns-in-matlab
Ys = Hs == max(Hs, [], 2);

end

