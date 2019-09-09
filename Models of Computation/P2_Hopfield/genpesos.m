function [T]=genpesos(pats);
%pats es una matriz donde cada columna es un vector;
m=size(pats,2); %número de patrones

T=zeros(100);
for i=1:m
    T=T+pats(:,i)*pats(:,i)';
end;

for i=1:100
    T(i,i)=0; % Elementos diagonales iguales a cero
end;
end

