function s = expStd(x)
%wrapper function to return the standard dev. of a fitted exponential distribution
	x = x(~isnan(x));
	a = expfit(x);
	[~,V] = expstat(a);
	s = sqrt(V);
end
    