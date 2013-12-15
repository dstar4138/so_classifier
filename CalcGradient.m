%% CalcGradient.m
%% 
%%  Calculates the gradient for a particular point given the variance of each 
%%  class and the mean of each class for the particular factor the point 
%%  belongs to. Note that since most datums we are working with are continuous
%%  we return a function rather than a lookup vector. 
%%
function MembershipFunction = CalcGradient( per_class_dist )
	distlen = size( per_class_dist, 2 );

	% For each distribution (gradient) of each class for 
	% this factor, find the density (percentage) at a 
	% given index.
	MembershipFunction = @internal_mf;
	function Dists = internal_mf( index )
		for ii = 1 : distlen
			cell_pd = per_class_dist(ii);
			Dists(ii) = pdf( cell_pd{1}, [ index ] );
		end
	end
end

