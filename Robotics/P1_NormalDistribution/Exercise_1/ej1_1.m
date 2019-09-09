disp('Ejercicio 1.1')
x = (-5:.1:5);
sigma = 1;
mu = 2;
e = exp(1);
norm = (1 / sqrt(2*pi*sigma^2)) * e.^( -(x-mu).^2 / (2*sigma^2) );
%norm = normpdf(x,mu,sigma);
figure;
plot(x,norm)