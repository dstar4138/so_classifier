# Spemann Organizer based Classification #

The following is an experiment done by students of the Biologically Inspired Intellegent Systems course at the Rochester Institute of Technology. We were tasked with designing an algorithm based on a reviewed biological process of our choosing. We present our concept of a  K-Factor Gradient Classifier based on the Spemann Organizer (or primitive knot).


## Usage ##

We provided a main script which will train and then test the classifier using a dataset and a ratio of training samples to use. The following example grabs the Iris dataset provided in the `data` directory and uses 70% of the samples for training and 30% for testing.

```MATLAB
>>> MainScript('iris_data.csv', 0.7)
```

We also provided a another dataset called `letter_recognition.csv`. This will take quite a bit longer to train and test due to the complexity and size. If you would like to provide your own dataset there are two constraints the current system has artificially put in place based on the current implementation and assumptions of `MainScript.m`. Namely that all factors must be numeric data, and the column with the known class must be on the far right.

## System Explanation ##

There are two primary algorithms `so_classifier` brings. These are the Training Algorithm and the Classifying algorithm.


### Training Algorithm ###

Training can either be done iteratively or all at once. As long as we can fit a distribution function to it. There are two steps after the data has been added to the distribution function which train the weighting and ranking:

* Weights are calculated for each class on each factor (the weight matrix is KxN), these weights are calculated using Index of Dispersion and capture how useful that factor is for a particular class. It does so by noticing when the distribution has a low variance and high mean.
* Ranks are calculated for each factor, they are found (currently) by looking at the modes of each class distribution and calculating the average after normalizing by the range. The rank is meant to capture how meaningful the factor is in general. If all distributions are overlapping then that factor doesn't provide much differentiation between classes and therefore shouldn't be weighted too heavily.

The resulting system is a weight matrix, a rank vector, and a distribution matrix.

### Classifying Algorithm ###

To classify a sample:

* For each factor in the sample, look it up in the distribution matrix for each class. 
    * The distribution matrix will return a list of densities. These represent how likely the sample belongs to each class (according to this particular factor).
    * Scale each density separately based on the weight matrix. This will dampen the density values if the class doesn't care about this factor. Otherwise it could enhance it.
    * The top scoring density is chosen and class it is from is selected as the class this factor chooses.
* Once you have a list of classifications based on each factor separately, we check if there are multiple that agree. If there is a single mode, we return that as the classification of the sample. Otherwise, we rely on rank and choose the highest ranked factor's classification.

## TODO ##

There are a couple portions which we would like to fix when we have some time:

* The classification algorithm is not at all optimized and was laid out in a way which is easier to read. Because of this the classification algorithm is very inefficient. We would like to vectorize it and look into options for pre-computing particular values beforehand.
* We want to also look at alternative weighting scenarios. Our current ranking system has a negative effect when the number of classes outweighs the number of factors.
