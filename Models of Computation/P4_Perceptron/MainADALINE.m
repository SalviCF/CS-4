% ADALINE (ADAptative LInear NEuron)
% Ver descripción ValoresIOT_ADALINE.m

clear;
clc;
close all;

% clasifica bien todos los conjuntos de datos excepto el DatosXOR 
% (ya que no es linealmenete separable)
load DatosLS50
% learning rate:
%      demasiado alto: no converge porque "se pasa").
%                      va pegando saltos alrededor del mínimo.
%      demasiado bajo: tarda mucho, demasiados cómputos.
LR=0.5; 
Limites=[-1.5, 2.5, -1.5, 2.5]; % límites del plot
MaxEpoc=100; % número máximo de veces que pasaré todos los patrones

W=PerceptronWeigthsGenerator(Data); % initial random weights (w1, w2, bias)
Epoc=1;

while ~CheckPatterns(Data,W) && Epoc<MaxEpoc
     for i=1:size(Data,1)
        [Input,Output,Target]=ValoresIOT_ADALINE(Data,W,i);
        
%         GrapDatos(Data,Limites);
%         GrapPatron(Input,Output,Limites); % azul: clasificación actual
%         GrapNeuron(W,Limites);hold off;
%         pause;
        
        % Le pongo la función signo por ser un problema de clasificación
        % Aunque la actualización se hace con el output continuo
        if Signo(Output)~=Target % si la clasificación del patrón no es correcta
           W=UpdateNet(W,LR,Output,Target,Input);
        end
        
%         GrapDatos(Data,Limites);
%         GrapPatron(Input,Output,Limites)
%         GrapNeuron(W,Limites);hold off;
%         pause;
     
     end
    Epoc=Epoc+1;
end

GrapDatos(Data,Limites);
GrapPatron(Input,Output,Limites)
GrapNeuron(W,Limites);

Epoc