%% MainScript.m
%% 
%%  Reads in a name of a dataset and then loads the dataset to memory. It will
%%  then randomly select half of population for each of the classifications
%%  to use for training of the classifier. We then call Test_Classifier.m for
%%  verifying the classification rate of the trained SO_Classifier.
%%
%%  Possible values for 
%%      - datafile_loc: 'iris_data.csv',
%%			'glass_data.csv',
%%			'winequality-red.csv', 'winequality-white.csv'
%%   
%%  Note All datasets must have the last column be the class/output-type, and
%%  all columns must be numeric, no textual or symbolic for the time-being.
%%
function[] = MainScript ( datafile_loc ) % dataset
    
    % All other data has been formatted to be the same:
    %   Classification type is stored on the last column.
    disp( ['Using: ' datafile_loc] )
    data = csvread( [ cd filesep 'data' filesep datafile_loc ] );
    
    [row column] = size(data);
    [x y] = hist(data(:,column))
    
    % Count the number of different classes.
    num_of_outputs = 0;
    for i = 1 : numel(x)
        if x(i)>0
            num_of_outputs = num_of_outputs +1;
        end
    end
    
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
    
    % Half the size of minimal occurance is used for testing
    minimal_test_size = min(array_output_type(2,:));
    half_min = round(minimal_test_size/2);
    
    % Randomly select portion for trainingData
    trainingData_index = zeros(half_min, num_of_outputs);
    for i = 1 : num_of_outputs
        temp_array = array_output_type(3:array_output_type(2,i),i);
        rand_elements = randperm( length(temp_array), half_min );
        trainingData_index( :, i ) = temp_array(rand_elements);
    end
    
    % Create TrainingData and TestData
    sorted_trainingData_index = sort(trainingData_index,'descend');
    TestingData = data;
    TrainingData = zeros(half_min*num_of_outputs, column);
    for index = 1 : numel(sorted_trainingData_index)
        TrainingData(index,:) = data( sorted_trainingData_index(index), :);
        TestingData(index,:) = [];
    end

    % Train the Spemann Organizer, will get back the Weighting system for each
    % factor and the K-Factor Gradient Matrix for each possible class.
    [weights, factorGradient] = ...
            Train_Spemann_Organizer( TrainingData, num_of_outputs, half_min );

    % Test the remaining data using the classifier. Will print percentages of
    % misclassified and correctly classified individuals from the test data.
%    Test_Classifier( TestingData, weights, factorGradient );
end
