function res = runScenario(sim_num)
%function runInitialCondition
 
    
    %Generate input for the simulation
    inputs = input_creator(sim_num);
    
    %load initial conditions used in publication (for reproducibility)
    load('eta_i_12_ic.mat'); 
    eta_i = 2*eta_i; %increase roughness of initial condition
    noIC = size(eta_i,1); %the rows of eta_i are the different initial conditions

    
    %results 'res' structure
    res = struct([]);
    
    %loop for each initial condition
    for idx = 1:noIC

        %run the simulation with the initial condition sourced from the
        %loaded array eta_i
        Z = oneDaetopo(inputs,eta_i(idx,:),idx,sim_num);

        %shift all elevations to be >= 0
        Z = Z + abs(min(Z(:)));

        % postprocess wavelength and celerity
        R = fastPost(Z,inputs,idx,sim_num,inputs.idx2smp);
        [res(idx).mPeriod,res(idx).WaveLen,res(idx).Cel] = waveLenCel2(Z,inputs.idx2smp,inputs.dx,inputs.dt,'dtw');

        % calculate equilibrium scales
        res(idx).heightEQ = eqScale(inputs.t2p,cellfun(@mean,R.duneHeights)); %height
        res(idx).celEQ = eqScale(inputs.t2p,res(idx).Cel);%celerity
        res(idx).lambdaEQ = eqScale(inputs.t2p,cellfun(@nanmean,res(idx).WaveLen)); %wavelength
        
        %time and horizontal scales for each simulation and I.C.
        res(idx).tS = inputs.t2p*(res(idx).celEQ/res(idx).lambdaEQ); %non-dimensional time
        res(idx).xS = inputs.x./res(idx).lambdaEQ; %non-dimensional horizontal distance
        %res(idx).etaS = Z./res(idx).heightEQ; %too memory intensive to
        %save all time steps (would be non-dimensional elevation)
    
        %dune/surface counts
        res(idx).noDunes = R.noDunes; %mean number of dunes per grid node
        res(idx).noSets = R.noSets; %mean number of sets per grid node
        
        %When does stratigraphy begin for each node
        res(idx).firstStep = R.firstStep;
        
        %dune scales
        res(idx).duneHeights = R.duneHeights;
        res(idx).duneTroughs = R.duneTroughs;
        res(idx).duneCrests = R.duneCrests;
        
        %dune scales for plotting
        res(idx).duneHeightsInt = R.duneHeightsInt;
        res(idx).duneTroughsInt = R.duneTroughsInt;
        res(idx).duneCrestsInt = R.duneCrestsInt;
        res(idx).setThickness = R.setThickness;
        
        %time total time and shredded time
        res(idx).stratTime = R.stratTime;
        res(idx).surfTime = R.surfTime;

    end