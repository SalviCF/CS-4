%Problema de las N torres
N=10;
W=zeros(N,N,N,N);
u=zeros(N,N);
S=ones(N,N);
%S=rand(N,N)
%S=round(S)
%pause
%Generaci�n de la matriz de pesos sin�pticos
for i=1:N
   for j=1:N
      for k=1:N
          W(i,j,i,k)=-1;
      end
   end
end 
for i=1:N
   for j=1:N
      for k=1:N
          W(i,j,k,j)=-1;
      end
   end
end 

for i=1:N 
   for j=1:N
       W(i,j,i,j)=2;
	end   
end

%W
%pause

%Din�mica de la Computaci�n
for r=1:N
   
   for i=1:N
         j=r+1-i;
      if j>0
           
         for h=1:N
            for s=1:N
               u(i,j)=u(i,j)+(S(h,s)*W(i,j,h,s));
            end
         end
         
         if u(i,j)>=0
            S(i,j)=1;
         elseif u(i,j)<=-1
            S(i,j)=0;
         else 
            S(i,j)=1-S(i,j);
         end
         
      else
         k=j+N;
         
         for h=1:N
            for s=1:N
               u(i,k)=u(i,k)+(S(h,s)*W(i,k,h,s));
            end
         end
         
         if u(i,k)>=0
            S(i,k)=1;
         elseif u(i,k)<=-1
            S(i,k)=0;
         else 
            S(i,k)=1-S(i,k);
         end

      end
  end
  S
  pause
end