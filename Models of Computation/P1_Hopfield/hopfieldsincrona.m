%RED de HOPFIELD binaria con actualización sincronizda. No garantiza el
%decrecimiento de la función de energía
clear
n=10; %número de neuronas de la red
ep=20;%número de ciclos o épocas

%Generación aleatoria de los pesos sinápticos
for i=1:n
    w(i,i)=0;
    for j=i+1:n
        w(i,j)=1-2*rand;
        w(j,i)=w(i,j);
    end
end

%Generar matrices como producto de un vector por sí mismo.
% x=rand(1,n);
% x=1-2*x;
% w=x'*x;
% for i=1:n
%   w(i,i)=0;
% end

o=rands(1,n); %Generación aleatoria de valores umbrales
s=ones(1,n); %estado inicial de las neuronas
sa=s;
E(1)=-0.5*s*w*s'+ o*s'; %Valor inicial de la función de energía computacional
iter=1; %primera ciclo o época de actualización
f=0; %parámetro de control de parada

for p=1:ep;% while f<1
   for k=1:n
    iter=iter+1; %nueva iteración   
    u(k)=s*w(:,k); %potencial sináptico
        if u(k)>o(k)
          sa(k)=1;
        elseif u(k)<o(k)
          sa(k)=0;  %estado actualizado
        else
          % s(k)=1-s(k);
        end
         d(k)=-(sa(k)-s(k))*(u(k)-o(k));
   end
   s=sa;
   drawnow
   imshow(s,'InitialMagnification','fit'); %imagesc(s)
 E(p)=-0.5*s*w*s'+o*s';  
%    if abs(E(iter)-E(iter-n))>0.0001
%    else
%        f=1;
%        t=iter; %total de iteraciones
%    end
   
   %drawnow
   %image(255*s)
   
end

figure,plot(1:ep,E(1,1:ep))
figure,imagesc(w)  %muestra la imagen de la matriz de pesos sinápticossegún sus valores (azul=más claro y rojo=más oscuro

    
    
        
