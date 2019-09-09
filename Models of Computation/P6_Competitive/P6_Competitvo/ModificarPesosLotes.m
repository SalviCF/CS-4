function new_W = ModificarPesosLotes(W,Ys,Data,LR)

% All weights are updated using modified learning rule
% The modified rule compesates the difference of size between groups

    new_W = W;
    for i = 1:size(W,2) % for each neuron
        neuron_i = W(:,i); % isolates neuron i (column i) 
        allDifferences = (Data - neuron_i'); % allPatterns - neuron(i)
        outputsForNeuron_i = Ys(:,i); % pattern outputs for the i-th neuron
        
        % outputsForNeuron_i indicates the rows to get (all rows)
        diffInWonPatterns = allDifferences(outputsForNeuron_i,:);
        
        % diffInWonPatterns has as many rows as won patterns
        update = mean(diffInWonPatterns,1) * LR; % mean of each column 
        new_W(:,i) = W(:,i) + update'; % update neuron_i
    end  
end

