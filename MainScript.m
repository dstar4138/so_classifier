function[] = MainScript () % dataset
    dataset = 'G:\Github\so_classifier\data\iris_data.txt';
    delimiterIn = ',';
    data = importdata(dataset, delimiterIn);
    data(1,1)
    
end
