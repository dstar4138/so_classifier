function[ weights, factorGradient ] = Train_Spemann_Organizer( trainingData )

    %initially values
    weights = ones( size(trainingData,1) );         %vector
    factorMean = zero( size(trainingData,1) );      %vector
    factorVariance = zero( size(trainingData,1) );  %vector
    factorGradient = zero( size(trainingData),1 );  %vector
    
    %assuming correct classification stored in column 1
    %look at each factor and get statistics of each column
    for eachFactor = 2: 1 : size(training_data,2)
        factorMean(eachFactor)      = mean(training_data);
        factorVariance(eachFactor)  = var(training_data);
        factorGradient(eachFactor)  = createGradient(factorMean, factorVariance);
    end
    
    %Neuron
    goal = .1  %ideally 0
    [weights, err] = applyNeuron( weights, factorGradient, goal);     

end
