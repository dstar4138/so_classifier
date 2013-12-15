%% Train_Spemann_Organizer.m
%%
%% Builds a weight vector and factor gradient matrix. The weight vector gives 
%% the usefulness of a particular factor, in terms of determining the final 
%% class. The factor gradient matrix gives the percentage at which a particular
%% value fits each class. The Spemann Organizer uses both to determine the 
%% final class of new data.
%%
function[ weights, rank, factorGradient ] = Train_Spemann_Organizer( trainingData, num_of_classes, num_per_class )

    % Get the Size of our training data
    [row column] = size(trainingData);
    
    % Locate the end of our data, we assume the final column is the class.
    lastfactor  = column - 1;

    % For each factor, we find the weight and the gradient.
    %  We define the weight of a factor to be equal to its index of dispersion:
    %		sqr(sigma)/mu, where sigma = variance, mu = mean
    %  We define the gradient of a factor to be a function which, for a given 
    %    index, returns a vector of membership percentages. In otherwords, the
    %    function gives how likely the new datapoint is apart of each class
    %    given just the value of one factor. Thus, the function is defined as:
    %		f( i ) = [ dist_1(i), dist_2(i), ..., dist_n(i) ] 
    for factor = 1 : lastfactor
        start = 0;
        stop = 0;

        for class = 1 : num_of_classes
            start = stop  + 1;
            stop  = start + num_per_class( class ) - 1;
            class_segment = trainingData( start:stop, factor );

            per_class_mean(class)  = mean( class_segment );
            per_class_range(class) = var( class_segment );
            per_class_dist(class)  = { fitdist( class_segment, 'Kernel' ) };
        end

        % Weights for the particular factor is the index of dispersion of each 
        % class. The "more different" each class is for a single factor, the 
        % more weight the particular factor brings to classifying each vector.
        %    For more: https://en.wikipedia.org/wiki/Index_of_dispersion
        weights( factor, : ) = per_class_range ./ per_class_mean;

	% The difference in the means somewhat captures the idea of how 
        % segregated the classes are because of this factor. If the difference
        % is high, then this factor should be ranked higher than others.
        rank( factor ) = abs( Sum_Of_Differences( per_class_mean ) );

        % Generate a lookup function for determining membership percentages.
        factorGradient( factor ) = { CalcGradient( per_class_dist ) };
    end


    % Display graphical views of the weights and factor gradients
    close all
    plot( rank ),
    title( 'Rank of each factor in terms of uniqueness' )

    plot( weights' )
    title('Factor Weights per Class')
    xlabel('Output Class')
    ylabel('Weight')
    set(gca, 'XTick', 1:num_of_classes );
    for factor = 1 : lastfactor
	cc = hsv( num_of_classes );
	start = 0;
	stop = 0;
        figure
        for output = 1 : num_of_classes
            start = stop  + 1;
            stop  = start + num_per_class( output ) - 1;
            hist( trainingData( start:stop, factor) );
            hold on;
        end
        title(strcat('Histogram of training data from input factor-', ...
            int2str(factor), ' : separated by different output classes'))
        xlabel('factor values')
        ylabel('factor Occurances')
        
        plot_handler = findobj(gca, 'Type', 'patch');
        
        for output = 1 : num_of_classes
            set(plot_handler(output), 'FaceColor', cc(output, :), 'EdgeColor', [0 0 0] );
        end
    end
end
