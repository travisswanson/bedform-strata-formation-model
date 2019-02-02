%script to run 3 model scenarios in Parallel

%number of scenarios to run
noSim = 3;

%structure to record simulation results 'res'
sim = struct([]);

%start parallel pool, run simulations, post-process results
parfor jdx = 1:noSim

    sim(jdx).res = runScenario(jdx);
 
end
