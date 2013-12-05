function[ classification ] = Spemann_Organizer_Classification( testSample, weights, factorGradient )

    p                       = zeros( size(testSample,2) );
    sampleGradient          = zeros( size(testSample,2) );
    factorWeights           = zeros( size(testSample,2) );
    scaledGradient          = zeros( size(testSample,2) );
    heights_of_scaledgrads  = zeros( size(testSample,2) );
    classify                = zeros( size(testSample,2) );

    %assuming correct classification stored in column 1
    for eachFactor = 2 : 1 : size(testSample,2)
        p = testSample(eachFactor);
        sampleGradient  = factorGradient[p];
        factorWeights   = weights[p];
        scaledGradient  = sampleGradient .* factorWeights;
        heights_of_scaledgrads = scaledGradient[ normalize(eachFactor) ];
        classify[p] = max_index( heights_of_scaledgrads );
    end
    
    classification = max(classify);
end
