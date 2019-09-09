clc;
clear;
close all;
load('Datos.mat');
% rng(1)

NumNeu=3;
LRini=0.7;
IterMax=1000;
% IterMax=1;
% ----Iniciar W------
[NumPat,NumInp]=size(Data);
Indices=ceil(rand(NumNeu,1)*NumPat);
% Indices=1:NumPat;
W=Data(Indices,:)';
% -----------------------


for i=1:IterMax
    i
    IndIter=ceil(rand(1,1)*NumPat);  %--Step 1
    Patron=Data(IndIter,:);
    
%     GrapEvol(Data,W,NumNeu,Patron)
%      pause
    
    LR=LRini*(1-i/IterMax);
    Hs=CalculoHs(W,Patron);
    Ys=CalculoYs(Hs);
    W=ModificarPesos(W,Ys,Patron,LR);
    
%     GrapEvol(Data,W,NumNeu,Patron)
%     pause
       
end

GrapFinal(Data,W,NumNeu,NumPat);
