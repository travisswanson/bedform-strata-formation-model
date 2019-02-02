function c = sim2cell(S,fn,noSmp,noRes)
%quick and dirty function to gather all results from each initial condition
%into a single cell element for each time interval.

c = {[]};

for jdx = 1:noSmp
        tmp = [];
        for idx = 1:noRes
            fc = getfield(S,{idx},fn,{jdx});
            tmp = [tmp; fc{:}];
        end
        c{jdx} = tmp;
end
