w=[0 0.0582 -0.4839 0.1267 -0.5362;
0.0582 0 -0.9408 0.2464 -1.0426;
-0.4839 -0.9408 0 -2.0496 -8.6721;
0.1267 0.2464 -2.0496 0 -2.2713;
-0.5362 -1.0426 -8.6721 -2.2713 0]

n=5
ep=20
o=rands(1,n); %Generaci�n aleatoria de valores umbrales
s=ones(1,n); %estado inicial de las neuronas
sa=s;
E(1)=-0.5*s*w*s'+ o*s'; %Valor inicial de la funci�n de energ�a computacional
iter=1; %primera ciclo o �poca de actualizaci�n
f=0; %par�metro de control de parada
for p=1:ep;% while f<1
   for k=1:n
    iter=iter+1; %nueva iteraci�n   
    u(k)=s*w(:,k); %potencial sin�ptico
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
   hold on;
% E(p)=-0.5*s*w*s'+o*s'
 %   if abs(E(iter)-E(iter-n))>0.0001
  %  else
   %     f=1;
    %    t=iter; %total de iteraciones
    %end
   
   %drawnow
   %image(255*s)
   
end

figure,imagesc(w)