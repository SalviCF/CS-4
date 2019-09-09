function [Trace]= signhop(utrace,Vtraceold);
%funci�n signo para el modelo de Hopfield
% utrace :potencial sin�ptico
% Vtrraceold: estado actual del vector (usado para casos donde utrace es cero)
sizet=size(utrace,1);
for i=1:sizet 
       if (utrace(i) > 0) Trace(i)=1;
       elseif (utrace(i)< 0) Trace(i)=-1;
       elseif (utrace(i)== 0) Trace(i)=Vtraceold(i);
end
end

 