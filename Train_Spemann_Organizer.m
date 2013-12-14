%% Train_Spemann_Organizer.m
%%
%% Builds a weight vector and factor gradient matrix. The weight vector gives 
%% the usefulness of a particular factor, in terms of determining the final 
%% class. The factor gradient matrix gives the percentage at which a particular
%% value fits each class. The Spemann Organizer uses both to determine the 
%% final class of new data.
%%
function[ weights, factorGradient ] = Train_Spemann_Organizer( trainingData, num_of_classes, num_per_class )

    % Initialize
    weights = 0;
    factorGradient = 0;

    % Get the Size of our training data
    [row column] = size(trainingData);
    
    % Locate the end of our data, we assume the final column is the class.
    lastparameter  = column - 1;

    % For each factor, we find the weight and the gradient.
    %  We define the weight of a factor to be equal to its index of dispersion:
    %		sqr(sigma)/mu, where sigma = variance, mu = mean
    %  We define the gradient of a factor to be a function which, for a given 
    %    index, returns a vector of membership percentages. In otherwords, the
    %    function gives how likely the new datapoint is apart of each class
    %    given just the value of one factor. Thus, the function is defined as:
    %		f( i ) = [ dist_1(i), dist_2(i), ..., dist_n(i) ] 
    for factor = 1 : lastparameter
        for class = 1 : num_of_classes
            start = ((class-1) * num_per_class) + 1;
            stop  = (start     + num_per_class) - 1;
            class_segment = trainingData( start:stop, factor );

            per_class_mean(class)  = mean( class_segment );
            per_class_range(class) = var( class_segment );
            per_class_dist(class)  = fitdist( class_segment, 'Kernel' );
        end

        % Weights for the particular factor is the dispersion of each class.
            % The more different each class is for a single factor, the more weight
            % the particular factor brings to classifying each vector.
        sigma = Sum_Of_Differences( per_class_mean ); 
        mu    = Sum_Of_Differences( per_class_range );
        weights( factor ) = sqrt( sigma ) / mu;

        % Generate a lookup function for determining membership percentages.
        factorGradient( factor ) = CalcGradient( per_class_dist );
    end


    % Display graphical views of the weights and factor gradients
    close all
    plot( weights )    
    for parameter = 1 : column-1
        start = (output-1) * num_per_class + 1
        stop  = start + num_per_class - 1
        figure
        for output = 1 : num_of_classes
            hist( trainingData( start:stop, parameter) );
            %change the color .. some how separate the outputs
            hold on;
        end
    end
end
