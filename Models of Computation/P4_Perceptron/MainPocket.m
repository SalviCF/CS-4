

% Perceptrón con bolsillo

clear;
clc;
close all;

% clasifica bien todos los conjuntos de datos excepto el DatosXOR 
% (ya que no es linealmente separable)
load DatosLS50
LR=0.5; % learning rate
Limites=[-1.5, 2.5, -1.5, 2.5]; % límites del plot
MaxEpoc=100; % número máximo de veces que pasaré todos los patrones

W=PerceptronWeigthsGenerator(Data); % initial random weights (w1, w2, bias)
Epoc=1;

run=0; % clasificaciones correctas consecutivas
run_w=0; % mayor nº de clasificaciones correctas consecutivas hasta el momento
W_pocket=W; % pesos guardados en el bolsillo

while true 
    update=false;
     for i=1:size(Data,1)
        [Input,Output,Target]=ValoresIOT(Data,W,i);
        
%         GrapDatos(Data,Limites);
%         GrapPatron(Input,Output,Limites); % azul: clasificación actual
%         GrapNeuron(W,Limites);hold off;
%         pause;
        
        % Pocket
        if Output~=Target % si la clasificación del patrón no es correcta
            W=UpdateNet(W,LR,Output,Target,Input);
            update=true;
            run=0;
        else
            run=run+1;
            if run>run_w
                run_w=run;
                W_pocket=W;
            end
        end
        
%         GrapDatos(Data,Limites);
%         GrapPatron(Input,Output,Limites)
%         GrapNeuron(W,Limites);hold off;
%         pause;
     end
    Epoc=Epoc+1;
    if update==false || Epoc>=MaxEpoc
        break; 
    end
end

GrapDatos(Data,Limites);
GrapPatron(Input,Output,Limites)
GrapNeuron(W,Limites);hold off;
