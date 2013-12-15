%% MainScript.m
%% 
%%  Reads in a name of a dataset and then loads the dataset to memory. It will
%%  then randomly select 'test_percent' of population of each classification
%%  to use for training of the classifier. We then call Test_Classifier.m for
%%  verifying the classification rate of the trained SO_Classifier.
%%
%%  Possible values for 
%%      - datafile_loc: 'iris_data.csv',
%%			'glass_data.csv',
%%			'winequality-red.csv', 
%%			'winequality-white.csv'
%%	- test_percent: 0.0 < x < 1.0 
%%   
%%  Note All datasets must have the last column be the class/output-type, and
%%  all columns must be numeric, no textual or symbolic for the time-being.
%%
function[] = MainScript ( datafile_loc, test_percent )
   
    % Verify parameters. 
    if test_percent <= 0.0 || test_percent >= 1.0
        disp(['ERROR: Invalid testing percentage : ' num2str(test_percent)])
        return
    end

    % All other data has been formatted to be the same:
    %   Classification type is stored on the last column.
    disp( ['Using: ' datafile_loc] )
    data = csvread( [ cd filesep 'data' filesep datafile_loc ] );
    
    % Get the size of our dataset.
    [row column] = size(data);
    
    % Count the number of different classes.
    num_of_outputs = size( unique( data( :, column ) ), 1);
    disp([ num2str(column-1) ' Factors, ' num2str(num_of_outputs) ' Classes'])
    
    % Create an index table:
    %   first row is the output type
    %   second row is counter
    %   third and above is the index
    array_output_type = zeros(1, num_of_outputs);
    fill = 0;
    for i = 1 : row
        element = data(i, column);
        member = ismember(array_output_type(1,:),element);
        ind = find(member>0);
        % new output goes to its own column
        if isempty(ind)
            fill = fill + 1;
            array_output_type(1,fill) = element;
            array_output_type(2,fill) = 1;
            array_output_type(3,fill) = i;
        % old output goes under its output type
        else
            array_output_type(2,ind) = array_output_type(2,ind) + 1;
            array_output_type(array_output_type(2,ind)+2,ind) = i;
        end
    end
    
    % Get certain percentage of each possible category. 
    take_counts = ceil( array_output_type( 2, : ) .* test_percent );

    % Randomly take percentage of each column and split into two lists of 
    % Indices
    [trainIdxs, testIdxs] = Take_Partition( take_counts, ...
                                            array_output_type( 3:end, : ));
        
    % Build TrainingData set
    for i = 1 : size( trainIdxs, 2 )
        TrainingData( i, : ) = data( trainIdxs(i), : );
    end

    % Build TestingData set
    for i = 1 : size( testIdxs, 2 )
        TestingData( i, : ) = data( testIdxs(i), : );
    end

    % Train the Spemann Organizer, will get back the Weighting system for each
    % factor and the K-Factor Gradient Matrix for each possible class.
    disp(['Training with ' num2str(size(TrainingData,1)) ' entries']);
    [weights, factorGradient] = ...
            Train_Spemann_Organizer( TrainingData, num_of_outputs, take_counts );

    % Test the remaining data using the classifier. Will print percentages of
    % misclassified and correctly classified individuals from the test data.
    Test_Classifier( TestingData, weights, factorGradient );
end
