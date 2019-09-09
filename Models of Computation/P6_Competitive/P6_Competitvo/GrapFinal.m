function GrapFinal(Data,W,NumNeu,NumPat)
clf
HsG=CalculoHs(W,Data);
YsG=CalculoYs(HsG);

for i=1:NumPat
    ind(i)=find(YsG(i,:));
end
colors = distinguishable_colors(NumNeu+1);

Inp=Data(:,1:end-1);
Out=Data(:,end);
for i=1:NumPat
    plot(Inp(i),Out(i),'Marker','o','LineStyle','none','Color',colors(ind(i)+1,:),'MarkerSize',10);hold on
end
for i=1:NumNeu
    plot(W(1,i),W(2,i),'Marker','o','LineStyle','none','Color',colors(i+1,:),'MarkerFaceColor',colors(i+1,:),'MarkerSize',10);hold on
end
    drawnow