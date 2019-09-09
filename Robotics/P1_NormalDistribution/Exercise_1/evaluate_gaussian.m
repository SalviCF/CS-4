function y = evaluate_gaussian( mu, sigma, x )
% Toma como  parámetros la media y la desviación de una distribución normal y el valor/es en la que se evalúa
disp('Ejercicio 1.2')
y = (1 / sqrt(2*pi*sigma^2)) * exp(1).^( -(x-mu).^2 / (2*sigma^2) );
% para ejecutar -> plot(x, evaluate_gaussian(mu, sigma, x))
end

