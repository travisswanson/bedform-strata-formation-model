%Script to re-create figures 2, 3, 4, 5, 6, and 7 from:

%Swanson, T., D. Mohrig, G. Kocurek, B. Cardenas, M. Wolinksy, 
%in preparation for Journal of Sedimentary Research, 
%Preservation of autogenic processes and allogenic forcings within
%set-scale aeolian architecture I: numerical experiments

%% Run the aeolian surface model 
% Run forward bedform strata-formation model and minimal post-processing
% using only initial condition '6' to create all stratigraphic sections 

%load initial conditions
load('eta_i_12_ic.mat');
eta_i = 2*eta_i;

noSim = 3;
noIC = 1; %only use one initial condition
ic2use = 6; %use this 

%Declare variables to hold results
Z = {[]};
Cel = {[]}; 
mWaveLen  = {[]};
mHeight = {[]};
mTrough = {[]};
mCrest= {[]};
heightEQ  = {[]};
celEQ= {[]};
lambdaEQ = {[]};

for jdx = 1:noSim %loop over three scenarios

    %simulation number = iteration counter
    sim_num = jdx;

    %create input 
    inputs = input_creator(sim_num);

    % run aeolian surface model
    Z{jdx} = oneDaetopo(inputs,eta_i(ic2use,:),noIC,sim_num);
    
    %find equilbrium scales (minimal post-processing)
    [~,~,Cel{jdx}] = waveLenCel2(Z{jdx},inputs.idx2smp,inputs.dx,inputs.dt,'dtw');
    [mWaveLen{jdx},mHeight{jdx},mTrough{jdx},mCrest{jdx}]=mScales(Z{jdx},inputs,inputs.idx2smp);
    heightEQ{jdx} = eqScale(inputs.t2p,mHeight{jdx});
    celEQ{jdx} = eqScale(inputs.t2p,Cel{jdx});
    mwlta = mWaveLen{jdx};
    lambdaEQ{jdx} = eqScale(inputs.t2p(~isnan(mWaveLen{jdx})),mwlta(~isnan(mWaveLen{jdx})));

end

%% Figure 2 - Earliest Stratigraphy

figure('position',[100 100 800 1000])

sim2plt =1; %Generate section using Scenario 1
etaS = Z{sim2plt}; 

%timing of sections
tStart = 400; %ic 6
tInt = 200; %interval to advance time in section plots

t1 = tStart; %time of each stratigraphic section plot
t2 = t1 + tInt;
t3 = t2 + tInt;

noSmp1 = 15; %sampling interval for each stratigraphic section subplot
noSmp2 = 15;
noSmp3 = 20;

topoScale= 1; %Topographic vertical exaggeration each stratigraphic section subplot
stratScale1 = 1/25; %Stratigraphic vertical exaggeration for each stratigraphic section subplot
stratScale2 = 1/25;
stratScale3 = 1/25;

%horizontal limits for stratigraphic sections
rLimit = 910; % ic = 6
lLimit = 870;

xS = inputs.x./lambdaEQ{sim2plt}; %non-dimensionalize horizontal distance
axisOff = false; %draw axis
mE = etaS(1:t3,:);
etaS = etaS + abs(min(mE(:)));
etaS = etaS./heightEQ{sim2plt};%non-dimensional topographic elevation

yll = 0.025; %vertical axis limits for plots
ylh = 0.13;

%make new figure and 3 subplots of stratigraphic section to time and horizontal
%limits
subplot(3,1,1)
    scaledSection2(etaS(1:t1,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp1,topoScale,stratScale1,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    ylim([yll ylh])
    title(['t = ' num2str(t1)])
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    colorbar
subplot(3,1,2)
    scaledSection2(etaS(1:t2,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp2,topoScale,stratScale2,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    ylim([yll ylh])
    title(['t = ' num2str(t2)])
    colorbar
subplot(3,1,3)
    scaledSection2(etaS(1:t3,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp3,topoScale,stratScale3,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    title(['t = ' num2str(t3)])
    ylim([yll ylh])
    colorbar
 
%% Figure 3 -   Erosion of earliest stratigraphy / formation of groups
figure('position',[100 100 1000 1000])

sim2plt = 1;%Generate section using Scenario 1
etaS = Z{sim2plt};

%time-limits for generating stratigraphic sections
tStart = 2000; %ic 6
tInt = 1000; 

t1 = 3000;%timestep for captuing each subplot
t2 = 4000;
t3 = 5000;

noSmp1 = 60; %sampling interval for each subplot
noSmp2 = 60;
noSmp3 = 60;

topoScale= 0.2; %topographic exageration for all subplots

%horizontal limits for sampling topo/stratigraphy
rLimit = 500; % ic = 6
lLimit = 320;

%Stratigraphic scale for each subplot
stratScale1 = 1/15;
stratScale2 = 1/15;
stratScale3 = 1/15;

%vertical axis limits
yll = 0;
ylh = 0.5;

axisOff = false; %draw axis
mE = etaS(1:t3,:);
etaS = etaS + abs(min(mE(:)));
etaS = etaS./heightEQ{sim2plt};%non-dimensional topographic elevation
xS = inputs.x./lambdaEQ{sim2plt};%non-dimensional horizontal distance

%make new figure and 3 subplots of stratigraphic section to time and horizontal
%limits
subplot(3,1,1)
    scaledSection2(etaS(1:t1,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp1,topoScale,stratScale1,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    ylim([yll ylh])
     title(['t = ' num2str(t1)])
     colorbar
subplot(3,1,2)
    scaledSection2(etaS(1:t2,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp2,topoScale,stratScale2,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    ylim([yll ylh])
     title(['t = ' num2str(t2)])
     colorbar
subplot(3,1,3)
    scaledSection2(etaS(1:t3,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp3,topoScale,stratScale3,axisOff)
    xlabel('x^{*}')
    ylabel('\eta^{*}')
    title(['t = ' num2str(t3)])
    ylim([yll ylh])
    colorbar

%% Figure 4 -  co-set w/ group topography
figure('position',[100 100 1000 1000])

axisOff = false;%draw axes

sim2plt = 2; %Generate section using Scenario 2
etaS = Z{sim2plt};
etaS = etaS + abs(min(etaS(:)));
etaS = etaS./heightEQ{sim2plt}; %non-dimensional topographic elevation
xS = inputs.x./lambdaEQ{sim2plt}; %non-dimensional horizontal distance

t1 = 65000; %end-timestep to generate section

mV = 350; %horizontal reference for section position
lLimit = 275 + mV; %horiztonal limits of plot
rLimit = 475 + mV ;

noSmp = 100; %sampling interval of topography in section generation
topoScale= 0.05; %topographic vertical exageration
stratScale = 1/50; %stratigraphic vertical exageration

%make new figure and plot stratigraphic section to time and horizontal
%limits             time,space             horizontal dis
scaledSection2(etaS(1:t1,lLimit:rLimit),xS(lLimit:rLimit),inputs,noSmp,topoScale,stratScale,axisOff)
xlabel('x^{*}')
ylabel('\eta^{*}')
title(['Scenario =' num2str(sim2plt)])
cbh = colorbar;
    
%% Figures 5, 6, and 7 - sections for each simulation
 
sS = [1/100 1/100 1/100]; %stratigraphic vertical exaggeration for each scenario
noSmp = 350; %number of time-steps to skip in generating plot
topoScale= 0.05; %topographic vertical exaggeration
axisOff = false; %draw axes

for idx = 1:noSim

    sim2plt = idx;

    %nondimensionalize topography
    etaS = Z{sim2plt};
    mE = etaS;
    etaS = etaS + abs(min(mE(:)));
    etaS = etaS./heightEQ{sim2plt};
    %nondimensionalize horizontal scale
    xS = inputs.x./lambdaEQ{sim2plt};
     
    %vertical exagg.
    stratScale = sS(idx);

    %make new figure and plot full stratigraphic section
    figure('position',[100 100 1000 500])
        scaledSection2(etaS,xS,inputs,noSmp,topoScale,stratScale,axisOff)
        xlabel('x^{*}')
        ylabel('\eta^{*}')
        title(['Scenario : ' num2str(sim2plt)])
        cbh = colorbar;
        ylabel(cbh,'Deposode');

end
