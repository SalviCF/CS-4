disp('Ejercicio 2.2')

n_samples = 10000;

mu1 = 1; sigma1 = 1; 
mu2 = 4; sigma2 = 2;

normal1 = sigma1 .* randn(n_samples,1) + mu1
normal2 = sigma2 .* randn(n_samples,1) + mu2;

suma = normal1 + normal2;

% suma será aquella normal que cumpla N(mu1+mu2, sqrt(sigma1^2 + sigma2^2))
% sigma_suma = sqrt(sigma1^2 + sigma2^2)

% stats = [mean(suma) std(suma)]
figure, histfit(normal1), title('N(1,1)');
figure, histfit(normal2), title('N(4,2)');
figure, histfit(suma), title('N(5,3)');
x=-10:.1:10;
y1=normpdf(x,mu1,sigma1);
y2=normpdf(x,mu2,sigma2);
z=normpdf(x, mean(suma),std(suma));
z2=conv(y1, y2);
figure, plot(x,y1,x,y2,x,z);
figure, plot(z2), title('conv');;


%{
Fuentes:
https://www.uv.es/ceaces/pdf/normal.pdf
https://es.mathworks.com/matlabcentral/answers/86136-convolution-of-two-functions
%}