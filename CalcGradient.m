%% CalcGradient.m
%% 
%%  Calculates the gradient for a particular point given the variance of each 
%%  class and the mean of each class for the particular factor the point 
%%  belongs to. Note that since most datums we are working with are continuous
%%  we return a function rather than a lookup vector. 
%%
function [ MembershipFunction ] = CalcGradient( per_class_dist )

	% For each distribution (gradient) of each class for 
	% this factor, find the density (percentage) at a 
	% given index.
	MembershipFunction = @(index) cellfun( @(p) pdf(p,[index]), ...
					       per_class_dist )

end
