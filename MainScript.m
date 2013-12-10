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
    
    [row column] = size(data)
    

    
    
end
