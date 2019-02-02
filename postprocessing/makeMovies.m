%Script to generate movies of topographic / stratigraphic co-evolution

%file names for video files of each scenario
file_names = {'scenarioOne','scenarioTwo','scenarioThree'};

noSim = 3; %number of scenarios to run
noIC = 1; %only run one initial condition
ic2use = 6; %simulation to use for movie generation

%load initial conditions
load('eta_i_12_ic.mat');

%fake-preallocate
Z = {[]};
Cel = {[]}; 
mWaveLen  = {[]};
mHeight = {[]};
mTrough = {[]};
mCrest= {[]};
heightEQ  = {[]};
celEQ= {[]};
lambdaEQ = {[]};

eta_i = 2*eta_i;

simulation = struct([]);

for jdx = 1:noSim %loop over each scenario

    %simulation number = iteration counter
    sim_num = jdx;

    % create input
    inputs = input_creator(sim_num);

    % run scenario
    Z{jdx} = oneDaetopo(inputs,eta_i(ic2use,:),noIC,sim_num);

    [mWaveLen{jdx},mHeight{jdx},mTrough{jdx},mCrest{jdx}]=mScales(Z{jdx},inputs,inputs.idx2smp);
    heightEQ{jdx} = eqScale(inputs.t2p,mHeight{jdx});

    mwlta = mWaveLen{jdx};

    lambdaEQ{jdx} = eqScale(inputs.t2p(~isnan(mWaveLen{jdx})),mwlta(~isnan(mWaveLen{jdx})));
    
end

%% Make movies of Topographic/Stratigraphic co-evolution

startingTimeStep = 5000;%timestep to start from. Default: t* = 0.2
timeInterval = 200; %number of time-steps between movie framts
frameRate = 5; %frame rate of movie

topoScale = 0.05; %vertical exageration of dune topography
stratScale = 1/100; %vertical exageration of stratigraphy
axisOff = false;

for idx = 1:noSim
    
    vidObj = VideoWriter([char(file_names(idx)) '.mp4'],'MPEG-4');
    vidObj.Quality = 100;
    vidObj.FrameRate = frameRate;
    
    sim2plt = idx;

    %nondimensionalize topography
    etaS = Z{sim2plt};
    mE = etaS;
    etaS = etaS + abs(min(mE(:)));
    etaS = etaS./heightEQ{sim2plt};
    %nondimensionalize horizontal scale
    xS = inputs.x./lambdaEQ{sim2plt};
    
    open(vidObj)
    
    figure('Position',[100,100,1800,900]);
    set(gca,'nextplot','replacechildren');
    set(gcf,'Renderer','Zbuffer');
    
    for t=startingTimeStep:timeInterval:(size(etaS,1)-1)

        scaledSection2(etaS(1:(t+1),:),xS,inputs,min(floor(t/50),300),topoScale,stratScale,axisOff)
        
        xlabel('x^{*}')
        ylabel('\eta^{*}')
        
        ylim([0 0.5])
        title(['t^{*} = ' num2str(round(t./inputs.nt,2))])
        set(gca,'FontSize',14)
        drawnow;
        
        %Add frame to video object
        currFrame = getframe(gcf);
        writeVideo(vidObj,currFrame);

    end
    
    %close video object / video file
    close(vidObj);
    
end

