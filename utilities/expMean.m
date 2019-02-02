function s = expMean(x)
%simple wrapper function to fine the mean value using a fitted exponential distribution
	%x = x(~isnan(x));
	a = expfit(x);
	[M,~] = expstat(a);
	s = M;
end