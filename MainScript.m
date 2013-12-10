function[] = MainScript ( dataset ) % dataset
    if dataset == 'iris'
        csv_data = strcat(cd, '\data\iris_data.csv');
        %Cannot load strings and numbers with csv.. dunno why
        %Iris output 1 = Iris-setosa
        %Iris output 2 = Iris-versicolor
        %Iris output 3 = Iris-virginica        
    elseif dataset == 'glass'
        csv_data = strcat(cd, '\data\glass_data.csv');
    elseif dataset == 'red_wine_quality'
        csv_data = strcat(cd, '\data\winequality-red.csv');
    else
        csv_data = strcat(cd, '\data\winequality-white.csv');
    end
    
    %all other data has been formatted to be the same.
    %Output type is stored on the last column
    data = csvread(csv_data);
    
    [row column] = size(data);
    [x y] = hist(data(:,column));
    
    %count the number of different outputs
    num_of_output = 0;
    for i = 1 : numel(x)
        if x(i)>0
            num_of_output = num_of_output +1;
        end
    end
    
    %Create an index table
    %first row is the output type
    %second row is counter
    %third and above is the index
    array_output_type = zeros(1, num_of_output);
    fill = 0;
    for i = 1 : row
        element = data(i, column);
        member = ismember(array_output_type(1,:),element);
        ind = find(member>0);
        %new output goes to its own column
        if isempty(ind)
            fill = fill + 1;
            array_output_type(1,fill) = element;
            array_output_type(2,fill) = 1;
            array_output_type(3,fill) = i;
        %old output goes under its output type
        else
            array_output_type(2,ind) = array_output_type(2,ind) + 1;
            array_output_type(array_output_type(2,ind)+2,ind) = i;
        end
    end
    
    %half the size of minimal occurance is used for testing
    minimal_test_size = min(array_output_type(2,:))/2;
    
    
end
