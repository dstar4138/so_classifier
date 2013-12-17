%% Spemann_Organizer_Classification.m
%%  
%%  Performs a lookup based on our trained weights and gradients each 
%%  particular factor. We then pick the most popular classification from
%%  the set of classified factors. This becomes our classification of the
%%  test sample.
%% 
function[ classification ] = Spemann_Organizer_Classification( testSample, weights, rank, factorGradient )

    % Assuming correct classification stored in final column
    num_of_factors = size(testSample, 2)-1;
    fill = 0;
    classify = zeros(1,3);

    % For each factor find the best classification. We could also find top two 
    % and perform a heuristic after the loop.
    for eachFactor = 1 : num_of_factors

        % Get the value of the particular factor.
        p = testSample( eachFactor );

        % Get our factor's lookup table.
        cell_gl = factorGradient( eachFactor );
        gradientlookup = cell_gl{ 1 };

        % Each factor has a set of weights based on how unique the factor is 
        % to the particular class.
        factorWeights   = weights( eachFactor );

        % For our factor, we get a set of densities for each class. This 
        % density represents the likelihood of membership that the sample
        % belongs to each class.
        sampleGradients = gradientlookup(p);

        % We scale each of the gradients to the weight from each class.
        heights  = sampleGradients .* factorWeights;

        % We then save the highest rated class for that factor (this step
        % can be modified with different effects).
        [~, i] = max( heights(:) );
        member = ismember( classify( :, 1 ), i );
        ind = find(member>0);
        if isempty(ind)
            fill = fill +1;
            classify(fill, :) = [ i , 1, rank( eachFactor ) ];
        else
            classify(ind, 2) = classify(ind,2)+1;
            classify(ind, 3) = classify(ind,3)+rank(eachFactor);
        end
    end

    % Sort based on mode.
    classify = sortrows(classify, -2);
    
    % If there are multiple of the same mode, choose highest rank.
    cur_mode = classify(1,2);
    if length(find(classify(:,2)==cur_mode)) > 1
	classify = sortrows( classify, -3 );
    end 

    % Otherwise, just return the most popular.
    classification = classify(1,1);

end
