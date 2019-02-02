function c = sim2cellNorm(S,fn,noSmp,noRes,nV)
%quick and dirty function to gather all results from each initial condition
%into a single cell element for each time interval.

c = {[]};

for jdx = 1:noSmp
        tmp = [];
        for idx = 1:noRes
            fc = getfield(S,{idx},fn,{jdx});
            tmp = [tmp; fc{:}./nV(idx)];
        end
        c{jdx} = tmp;
end
