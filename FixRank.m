%% FixRank.m
%%
%%  There are several ways of modifying which factors have the most influence
%%  in the system. In this method, we just take the top N ranks and zero out 
%%  the rest in place. This has the effect of only considering the top factors
%%  in the event of having multiple competing classifications.
%%
function [ rank ] = FixRank( r )

	% Take top N
	N = min( 5, length(r));

	% Sort the ranks and get the final index locations	
	[~, sortedIndex] = sort( r, 'descend' );
        topN = sortedIndex(1:N);
	
	% Zero out all other ranks and only keep the top N.
	rank = zeros(1,length(r));
	for i = 1:N
		ind = topN(i);
		rank(ind) = r(ind);
	end
end
