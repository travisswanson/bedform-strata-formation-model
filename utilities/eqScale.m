function EQscale = eqScale(x,y)
%function to fit regression model of type a*(1-exp(-b*x))
%while filtering out nan's, returns saturated value 'a'

li = isnan(x) | isnan(x);

x(li) = [];
y(li) = []; 

x = x(:);
y = y(:);

p0 = [max(y)-abs(min(y)),1];

ft = fittype('a*(1-exp(-b*x))');
fo = fit(x,y,ft,'StartPoint', p0);

EQscale = fo.a;
end
