%% Take_Partition.m
%%
%%  Used from MainScript to partition several columns of indices into two
%%  sets based on a vector of item counts.
%%
function [ aset, bset ] = Take_Partition( counts, col_mat ) 
	% Initialize
	aset = [];
	bset = [];

	% For each column, break it into two parts and add the first
	% to the A set, and the second the the B set.
	for col = 1 : length(counts)
		cur_count = counts( col );           % partition index
		idxs = col_mat( :, col )';           % get list of indexs
		idxs = idxs(randperm(length(idxs))); % random sort
		idxs( idxs == 0 ) = [];              % Remove zeros
		for i = 1 : cur_count
			aset=[aset; idxs(i)];
		end
		for i = cur_count+1 : length(idxs)
			bset=[bset; idxs(i)];
		end
	end
	
	% Rotate them, since we want them in vector form.
	aset = aset';
	bset = bset';
end
