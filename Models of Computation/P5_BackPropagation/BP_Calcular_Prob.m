function Accuracy = BP_Calcular_Prob(Network_PCFinal,tests,Par)
% Se comprueba la accuracy de la red con el dataset de test.
% accuracy = patrones bien calsificados / patrones totales

    % Init
    hTest=cell(1,Par.NumLayer);
    STest=cell(1,Par.NumLayer);
    
    for N=1:Par.NumLayer
        hTest{N}=zeros(1,Par.NumNeu(N));
        STest{N}=zeros(1,Par.NumNeu(N));
    end

    Aciertos=0;
    Fallos=0;

    for i=1:length(tests)
        PatternTest=tests(i,1:Par.NumNeu(1)); % current pattern
        TargetTest=tests(i,Par.NumNeu(1)+1:end); % current target
        [YTest,hTest] = BP_Output_Neurona(Network_PCFinal,hTest,STest,PatternTest,Par);
        
        if round(YTest{end})==TargetTest  
            Aciertos=Aciertos+1;
        else
            Fallos=Fallos+1;
        end
    end
     
     Accuracy=Aciertos/(Aciertos+Fallos);

end

