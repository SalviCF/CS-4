disp('Ejercicio 2_4')

n_samples = 10000;
mu1 = 1; sigma1 = 1; 

normal1 = sigma1 .* randn(n_samples,1) + mu1;
figure, histfit(normal1), title('Normal N1');

transformada = normal1 * 2 + 2;
figure, histfit(transformada), title('Transformación lineal de N1');

trans_nolineal = normal1.^2 + 2;
figure, histfit(trans_nolineal), title('Transformación no lineal de N1');

%{
Para la función y = x^2+ 2 no funciona porque no es lineal.
%}