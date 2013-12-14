%% Spemann_Organizer_Classification.m
%%  
%%  Performs a lookup based on our trained weights and gradients each 
%%  particular factor. We then pick the most popular classification from
%%  the set of classified factors. This becomes our classification of the
%%  test sample.
%% 
function[ classification ] = Spemann_Organizer_Classification( testSample, weights, factorGradient )

    % Assuming correct classification stored in final column
    num_of_factors = size(testSample, 2)-1;

    % Initialize.
    p                       = zeros( num_of_factors );
    sampleGradient          = zeros( num_of_factors );
    factorWeights           = zeros( num_of_factors );
    scaledGradient          = zeros( num_of_factors );
    heights_of_scaledgrads  = zeros( num_of_factors );
    classify                = zeros( num_of_factors );

    % For each factor find the best classification. We could also find top two 
    % and perform a heuristic after the loop.
    for eachFactor = 1 : num_of_factors

        % Get the value of the particular factor.
        p = testSample( eachFactor );

        % Get our factor's lookup table.
        gradientlookup = factorGradient( eachFactor )

        % Each factor has a weight based on how unique the factor is.
        factorWeight    = weights( eachFactor );

        % For our factor, we get a set of densities for each class. This 
        % density represents the likelihood of membership that the sample
        % belongs to each class. (the one is because its in a cell).
        sampleGradients = gradientlookup( p ); % This is a function, not an array.

        % We scale each of the gradients to the weight.
        heights_of_scaledGradient  = sampleGradients .* factorWeight;

        % We then save the highest rated class for that factor (this step
        % can be modified with different effects).
        classify( eachFactor ) = max_index( heights_of_scaledgrads );
    end

    % We pick the most common classification. If there isn't one we 
    % can fall back to the weighting system and pick one based on that.
    classification = mode(classify);
end
