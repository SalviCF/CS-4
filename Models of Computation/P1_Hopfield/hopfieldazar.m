%RED de HOPFIELD binaria 0-1 actualizacón secuencial aleatoria 
clear
n=10; %número de neuronas de la red
%Generación aleatoria de los pesos sinápticos
for i=1:n
    w(i,i)=0;
    for j=i+1:n
        w(i,j)=1-2*rand;
        w(j,i)=w(i,j);
    end
end

o=rands(1,n); %Generación aleatoria de valores umbrales
s=ones(1,n); %estado inicial de las neuronas
E(1)=-0.5*s*w*s'+ o*s'; %Valor inicial de la función de energía computacional
iter=1; %primera ciclo o época de actualización
f=0; %parámetro de control de parada

while f<1
   for i=1:n
    iter=iter+1; %nueva iteración   
    k=fix(1+n*rand); %elección aleatoria de la neurona a actualizar
    u=s*w(:,k); %potencial sináptico
        if u>o(k)
          sa=s(k); %estado anterior
          s(k)=1;
        elseif u<o(k)
          sa=s(k); %estado anterior
          s(k)=0;  %estado actualizado
        else
          sa=s(k); %estado anterior
          % s(k)=1-s(k);
        end
         d(i)=(sa-s(k))*(u-o(k));
         E(iter)=E(iter-1)+d(i);
         
         drawnow
         imshow(s,'InitialMagnification','fit'); %imagesc(s)
   end
   
   if abs(E(iter)-E(iter-n))>0.0001
   else
       f=1;
       t=iter; %total de iteraiones
   end
   
%    drawnow
%    image(255*s)
   
end

figure,plot(1:t,E(1,1:t))
figure,imagesc(w)  %muestra la imagen de la matriz de pesos sinápticossegún sus valores (azul=más claro y rojo=más oscuro

 disp(iter)   
    
        
