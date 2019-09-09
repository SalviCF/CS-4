function GrapDatos(Data,Limites)
Inp=Data(:,1:end-1);
Out=Data(:,end);
plot(Inp(Out==1,1),Inp(Out==1,2),'rx');hold on;
plot(Inp(Out==-1,1),Inp(Out==-1,2),'go');hold on;
axis(Limites)