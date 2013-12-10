function[ weights, factorGradient ] = Train_Spemann_Organizer( trainingData, num_of_outputs, num_per_output )
    [row column] = size(trainingData);
    colormap = hsv(column-1);
    close all
    for output = 1 : num_of_outputs
        %all means are stored in row 1 
        %all variance are stored in row 2
        factor_stats = zeros(2, column-1);

        start = (output-1) * num_per_output + 1
        stop  = start + num_per_output - 1

        factor_stats(1,:) = mean(trainingData( start:stop, 1:column-1));
        factor_stats(2,:) = var(trainingData( start:stop, 1:column-1));

        Mean_Diff = Sum_Of_Differences( factor_stats(1,:) );
        Var_Diff = Sum_Of_Differences( factor_stats(2,:) );

        weights(output) = Mean_Diff/Var_Diff;
    end
    
    
    for parameter = 1 : column-1
        start = (output-1) * num_per_output + 1
        stop  = start + num_per_output - 1
        figure
        for output = 1 : num_of_outputs
            hist( trainingData( start:stop, parameter) );
            %change the color .. some how separate the outputs
            hold on;
        end
    end
    
factorGradient=0;
end
