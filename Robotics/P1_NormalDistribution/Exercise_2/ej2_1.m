disp('Ejercicio 2.1')

n = 1000;
N = 1000000;

vector_suma = 0;
for i=1:N
   vector_suma = vector_suma + rand(n,1);
end

vector_suma = vector_suma / N
figure, hist(rand(n,1), 30);
figure, histfit(vector_suma, 30);