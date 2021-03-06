%% Test_Classifier.m
%%
%%  Will run through all rows in Testing Data given to it and will
%%  Check what it's classification is by checking it against the 
%%  Spemann Organizer Classifier. It keeps track of the valid and
%%  invalid classifications and will give those percentages at the
%%  end.
%%
function [] = Test_Classifier( TestingData, class_names, weights, rank, factorGradient )

    % Number of Rows in the Testing Data ( # of Samples )
    NumberOfTests   = size( TestingData, 1 );
    NumberOfMatches = 0;
    NumberOfFails   = 0;

    disp( ['Testing the trained Classifier: ' num2str(NumberOfTests)] );


    % Assume Classification is stored in the last column for normalized data.
    class = size( TestingData, 2 );

    % Run through all tests.
    for sample = 1 : NumberOfTests
        
        real_classification = TestingData( sample, class );

        [ class_index ] = ...
             Spemann_Organizer_Classification( TestingData( sample, : ), ...
                                               weights, rank, factorGradient );
        classification = class_names( class_index );

        if classification == real_classification 
            NumberOfMatches = NumberOfMatches + 1;
        else
            NumberOfFails = NumberOfFails + 1;
        end
    end 

    % Print Our Statistics.
    disp('Percent of Hits');    disp( NumberOfMatches / NumberOfTests );
    disp('Percent of Misses:'); disp( NumberOfFails / NumberOfTests );
end
