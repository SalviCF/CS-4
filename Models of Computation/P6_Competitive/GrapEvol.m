function GrapEvol(Data,W,NumNeu,Patron)
    
    clf
    colors = distinguishable_colors(NumNeu+1);
    Inp=Data(:,1:end-1);
    Out=Data(:,end);
    plot(Inp,Out,'Marker','o','LineStyle','none','Color',colors(1,:));hold on
    plot(Patron(1:end-1),Patron(end),'Marker','o','LineStyle','none','Color',colors(1,:),'MarkerFaceColor',colors(1,:));hold on
  
    for i=1:NumNeu
        plot(W(1,i),W(2,i),'Marker','o','LineStyle','none','Color',colors(i+1,:),'MarkerFaceColor',colors(i+1,:));hold on
    end
    drawnow