function GrapPatron(Inp,Out,Limites)
if Out==1
    plot(Inp(1),Inp(2),'bx');hold on;
else
    plot(Inp(1),Inp(2),'bo');hold on;
end
axis(Limites)