The following DataSets were taken from UCI's dataset repository. We have 
modified them only slightly to make them easier to parse using built in MATLAB 
functions. We record our modifications here.


`iris_data.csv` - 
* Location: http://archive.ics.uci.edu/ml/datasets/Iris
* Modifications:
    * Converted string classification with integer: (1 = Setosa, 2 = Versicolor, 3 = Virginica)


`letter_recognition.csv` - 
* Location: http://archive.ics.uci.edu/ml/datasets/Letter+Recognition
* Modifications:
    * Classification has been moved to rightmost column.
    * Classification has been converted to numeric value (A=1, B=2, etc).
