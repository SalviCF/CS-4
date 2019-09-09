function [Y]=derivar(X) 
% X: número/vector de números tras pasarlos por la sigmoide

Y=X.*(1-X); % f'(x) = f(x) * (1-f(x)) ; siendo f la sigmoide