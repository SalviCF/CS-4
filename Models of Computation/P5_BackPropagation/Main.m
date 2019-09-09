% 60%-40%
% Algoritmo que divide el conjunto de patrones en 2 partes uno para train
    % y otro para test.
% Calcula el tiempo que tarda en realizar una iteracion en función de las
    % neuronas.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
rng(1)
%Reg_Cla='Regresion/';
% Data=load([Reg_Cla 'D_Airfoil']);Neu=[5  1]; 
% Data=load([Reg_Cla 'D_C_C_Power_Plant']);Neu=[4  1]; 
%Data=load([Reg_Cla 'D_Concrete_Com_Str']);Neu=[8 1];
% Data=load([Reg_Cla 'D_Concrete_Slump']);Neu=[10 1]; 
% Data=load([Reg_Cla 'D_Energy_Efficient_A']);Neu=[8 1];
% Data=load([Reg_Cla 'D_Energy_Efficient_B']);Neu=[8 1];
% Data=load([Reg_Cla 'D_Forest_Fire']);Neu=[12 1];
% Data=load([Reg_Cla 'D_Housing']);Neu=[13 1];
%  Data=load([Reg_Cla 'D_Parkinson_Telemonit']);Neu=[21 1];
%  Data=load([Reg_Cla 'D_WineQuality_Red']);Neu=[11 1];
%  Data=load([Reg_Cla 'D_WineQuality_White']);Neu=[11 1];
% Data=load([Reg_Cla 'D_Yacht_Hydrodynamics']);Neu=[6  1]; 

Reg_Cla='Clasificacion/';
% Data=load([Reg_Cla 'D_Blood_Transfusion']);Neu=[4  1]; 
% Data=load([Reg_Cla 'D_Cancer']);Neu=[9  1]; 
% Data=load([Reg_Cla 'D_Card']);Neu=[51 1];
% Data=load([Reg_Cla 'D_Climate']);Neu=[18 1]; 
 Data=load([Reg_Cla 'D_Diabetes']);Neu=[8 1];
% Data=load([Reg_Cla 'D_heartc']);Neu=[35 1];
% Data=load([Reg_Cla 'D_Ionosphere']);Neu=[34 1];
% Data=load([Reg_Cla 'D_Sonar']);Neu=[60 1];
%  Data=load([Reg_Cla 'D_Statlog(Heart)']);Neu=[13 1];
%  Data=load([Reg_Cla 'D_Vertebral_Column']);Neu=[6 1];

Data=Data.data; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Network structure [input-layer-neurons, hidden-layers-neurons, output-layer-neurons]
Parameter.NumNeu=[Neu(1) 10 Neu(2)];

Parameter.Eta=0.1; % learning rate
Parameter.NumEpoch=500; % one pass, presenting all training patterns

% Número de capas de la red (1 oculta y la de salida, no contamos el input)
% https://datascience.stackexchange.com/questions/14027/counting-the-number-of-layers-in-a-neural-network
Parameter.NumLayer=length(Parameter.NumNeu)-1;

[FilData,ColData]=size(Data); % filas y columnas del dataset

Data2=Data(randperm(FilData),:);%Data2=Data;
%Data2=Data;

% Probabilidades
ProbTrain=0.5;
ProbValid=0.3;
ProbTests=0.2;

% Filas para los distintos datasests los datasets
FilaTrain=fix(FilData*ProbTrain);
FilaValid=fix(FilData*(ProbValid));
FilaTests=FilData-FilaTrain-FilaValid;

% Divido los datos en tres datasets (entrenamiento, validación, test)
Datos.Train=Data2(1:FilaTrain,:);
Datos.Valid=Data2(FilaTrain+1:FilaTrain+FilaValid,:);
Datos.Tests=Data2(FilaTrain+FilaValid+1:end,:);

% Número de patrones de los conjuntos de entrenamiento y validación
[NumPatTra,~]=size(Datos.Train);
[NumPatVal,~]=size(Datos.Valid);


%%%%%%%%%%% Step 0: INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Init array de matrices. Acceso: Network_PC{1}, Network_PC{2}
% Tenemos un array de 1x2 (NumLayer es 2). Cada elemento es una matriz.
% Cada elemento del array Network_PC (Por Capas) representa los pesos de una capa.
Network_PC=cell(1,Parameter.NumLayer); % pesos sinápticos
h_PC=cell(1,Parameter.NumLayer); % potenciales sinápticos
S_PC=cell(1,Parameter.NumLayer); % salidas de las neuronas
Deltas_PC=cell(1,Parameter.NumLayer); % errores de las neuronas

% Initialization
for N=1:Parameter.NumLayer
    h_PC{N}=zeros(1,Parameter.NumNeu(N)); % potenciales sinápticos en cada capa
    S_PC{N}=zeros(1,Parameter.NumNeu(N)); % salias de la neuronas en capa capa
    Deltas_PC{N}=zeros(1,Parameter.NumNeu(N)); % errores neuronas en cada capa
    % Pesos desde el input a la hidden y de la hidden a la capa de salida
    % La primera matriz del array es de 8x10: 
        % 8 neuronas de entrada conectadas cada una con las 10 neuronas de
        % la capa oculta.
    Network_PC{N}=randn(Parameter.NumNeu(N),Parameter.NumNeu(N+1)); 
    % Network_PC{N}=0.1*ones(Parameter.NumNeu(N),Parameter.NumNeu(N+1));
    
end

% Diferencias entre targets y salidas (init)
DiferT_PC=zeros(Parameter.NumNeu(end),NumPatTra);
Difer2T_PC=zeros(Parameter.NumNeu(end),NumPatTra);
DiferV_PC=zeros(Parameter.NumNeu(end),NumPatVal);
Difer2V_PC=zeros(Parameter.NumNeu(end),NumPatVal);

ErrorFinal_PC=Inf; % infinity at init


%%%%%%%%%%%%%%%%%%%%%%% TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for NumEpoc=1:Parameter.NumEpoch
  NumEpoc
%   p=NumPatTra:-1:1;
     p=1:NumPatTra; % identificador del patrón
     for i=1:NumPatTra % para todos los patrones de entrenamiento
         Pattern=Datos.Train(p(i),1:Parameter.NumNeu(1)); % patrón actual
         Target=Datos.Train(p(i),Parameter.NumNeu(1)+1:end); % salida objetivo para ese patrón 
         % según los datos, tendrá una o más salidas
         
         % FORWARD PASS
         [S_PC,h_PC] = BP_Output_Neurona(Network_PC,h_PC,S_PC, Pattern, Parameter); % salida y potencial
         
         % COST OF THE NETWORK 
         DiferT_PC(:,i)=(Target-S_PC{end}); % error_i = target-salida
         
         % BACKPROPAGATION PASS (ERROR IN THE LAYERS)
         Deltas_PC=BP_Calculo_Deltas(S_PC,Deltas_PC,DiferT_PC(:,i),Network_PC,Parameter);
         
         % WEIGHTS UPDATE
         Network_PC=BP_Incrementar_Pesos(Network_PC,Deltas_PC,S_PC,Pattern,Parameter);
     end
   
% TRAIN VS VALIDATION RESULTS %
Difer2T_PC=DiferT_PC.^2;
ErrorIter_PC=sum(sum(Difer2T_PC))/NumPatTra;
MSE.PC.Train(NumEpoc)=ErrorIter_PC;   

q=NumPatVal:-1:1;
    for i=1:NumPatVal
         Pattern=Datos.Valid(q(i),1:Parameter.NumNeu(1));
         Target=Datos.Valid(q(i),Parameter.NumNeu(1)+1:end);
 
         [S,h] = BP_Output_Neurona(Network_PC,h_PC,S_PC,Pattern,Parameter);
         DiferV_PC(:,i)=(Target-S{end});
     end  
     Difer2V_PC=DiferV_PC.^2;
     ErrorValid_PC=sum(sum(Difer2V_PC))/NumPatVal;
     MSE.PC.Valid(NumEpoc)=ErrorValid_PC;
     
     if ErrorValid_PC<ErrorFinal_PC
         Iteration_PC=NumEpoc;
         Network_PCFinal=Network_PC;
         ErrorFinal_PC=ErrorValid_PC;
     end

end
  
MSE.PC.Prob=BP_Calcular_Prob(Network_PCFinal, Datos.Tests,Parameter);


plot(MSE.PC.Train,'LineStyle','-','Color',[1 0 0],'LineWidth',3);hold on;
plot(MSE.PC.Valid,'LineStyle',':','Color',[0 0 1 ],'LineWidth',3);hold on;

LimiteY=min(0.4,max(max(MSE.PC.Train,MSE.PC.Train)));
axis([0 Parameter.NumEpoch 0 LimiteY])
legend('PC Train','PC Validation');

