disp('Ejercicio 1.4')
n1 = 100; 
n2 = 500;
n3 = 1000;
mu = 2; sigma = 2;
x = sigma .* randn(n3,1) + mu;
figure, histfit(x);
% También con: histfit(normrnd(2,2,[1,n1]));

%{
Fuentes:
https://es.mathworks.com/help/stats/histfit.html
%}