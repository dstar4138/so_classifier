%% Sum_Of_Differences.m
%% 	
%%  Given an array of numbers this will return a single value which is the
%%  sum of differences of all values in the array.
%%
function [ total_Diff ] = Sum_Of_Differences( array )
    % Make matrix of all the differences
    x = array';
    D = squareform( pdist(x,@(p,q)q-p) );
    U = triu(D);
    L = tril(D);
    y = flipud(fliplr( L(:,1:end-1) - U(:,2:end) ));
    
    [row column] = size(y);
    
    %only take one occurance
    shift = 1;
    i = 0;
    for r = 1 : row
        for c = shift : column
            i = i + 1;
            output(i) = abs( y(r,c) );
        end
        shift = shift + 1;
    end
    
    %take the total
    total_Diff = sum(output);
end
