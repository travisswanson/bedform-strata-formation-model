function cov = gammaCov(x)
%wrapper function to find coefficent of variation using fitted gamma distribution
%     x = x(~isnan(x));
	a = gamfit(x);
	[M,V] = gamstat(a(1),a(2));
	cov = sqrt(V)./M;
end