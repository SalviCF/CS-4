disp('Ejercicio 1.3')
% Creamos el vector con los n�meros aleatorios 
% Estos n�meros aletorios siguen una distribuci�n normal mu=2, sigma=2
mu = 2; sigma = 2; n = 200;
y = sigma .* randn(n,1) + mu;
x = zeros(n,1); % ya que scatter recibe dos par�metros
scatter(y,x)

%{
Respuestas:

3.1 
Los puntos se concentran en torno al 2, ya que es la media de la
distribuci�n. Esto es debido al uso de la funci�n randn, que genera los
valores aleatorios normalmente distribuidos y, por tanto, su m�ximo est� en
x = mu

3.2
Cuanto m�s nos alejemos de x = mu, menor ser� la concentraci�n de valores.
Es lo que se conoce como "campana de Gauss", los valores crecen hasta la 
media y decrecen a partir de ella.
%}

%{
Fuentes:
https://es.mathworks.com/help/matlab/math/random-numbers-with-specific-mean-and-variance.html
https://es.mathworks.com/matlabcentral/answers/247686-what-difference-does-it-make-if-we-use-rand-and-randn
%}

