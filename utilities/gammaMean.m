function M = gammaMean(x)
%wrapper function to find mean using fitted gamma distribution
	%x = x(~isnan(x));
    a = gamfit(x);
    [M,~] = gamstat(a(1),a(2));
end
    