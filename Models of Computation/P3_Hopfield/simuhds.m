function [x] = simuhds(x,w,sincrona,max_iter)

% SIMUHDS Simulacion de la Red Hopfield Discreta Simetrica.
%         tanto para el caso Asincrono como el Sincrono.
%
%   X = SIMUHDS(X0,W,SINCRONA,MAX_ITER).
%     X0    - Matriz de los vectores de entradas X.
%     W     - Matriz de pesos.
%     SINCRONA - Tipo de red:
%              sincrona=0 --> red asincrona.
%              sincrona=1 --> red sincrona.
%             por defecto sera asincrona.
%     MAX_ITER - Numero maximo de iteraciones para la simulacion.
%             por defecto sera hasta la estabilidad.
%   Salida:
%     X     - Matriz de salida X.
%
%   Notas: Los valores de las matriz X son [-1 1].
%
%   Mirar ademas: HOP, SIMUHD, SIMUHC, SIMUHCS, SOLVEH, SOLVEHS.

% Realizado por Antonio F. Urdiales Urdiales.
% Version 1.1 (10-5-96)

if nargin < 2,
  error('Faltan argumentos de entrada.');
end
if nargin < 3
  sincrona = 0;
end
if nargin < 4,
  max_iter=Inf;
end

[filax,columx]=size(x);
fin=0;
iter=0;
while fin==0,
  xx=x;
  iter=iter+1;
  if sincrona==1,
    xx=limits(w*x,x);

  elseif sincrona==0,
    mirada=zeros(1,filax);
    while sum(mirada)~=filax,
      alea=floor(rand*filax+1);
      xx(alea,:)=limits(w(alea,:)*xx,xx(alea,:));
      mirada(1,alea)=1;
    end

  else
    error('El valor de sincrona debe ser 0 o 1');
  end
  if xx==x | iter >= max_iter,
     fin=1;
  end
  x=xx;
end
