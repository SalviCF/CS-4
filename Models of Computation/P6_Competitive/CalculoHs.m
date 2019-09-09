function Hs = CalculoHs(W, Patron)

% h_i = w_i1 * x_1 + ... + w_in * x_n - theta_i
% theta_i = (1/2) * (w^2_i1 + w^2_i2 + ... + w^2_in)

theta = 1/2 * sum(W.^2);
Hs = Patron * W - theta;

end

