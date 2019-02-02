function s = gammaStd(x)
%wrapper function to find standard dev of fitted gamma distribution
    x = x(~isnan(x));
    a = gamfit(x);
    [~,V] = gamstat(a(1),a(2));
    s = sqrt(V);
end
    