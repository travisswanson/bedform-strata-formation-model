%Figures 1, 8, 8 Inset, 9, and 10 from:

%Swanson, T., D. Mohrig, G. Kocurek, B. Cardenas, M. Wolinksy, 
%in preparation for Journal of Sedimentary Research, 
%Preservation of autogenic processes and allogenic forcings within
%set-scale aeolian architecture I: numerical experiments

%And two unpublished figures:


%local variables used for plotting
sym2plt = {':','--','-'};
noSim= 3;
minSetThickness = 0.01;

%% Scenario forcing plot (Unpublished figure)
figure('position',[100 100 600 600])

pltSkp = 250;

for idx = noSim:-1:1

    i2p = input_creator(idx);
    it2p = (1:length(i2p.tab))./length(i2p.tab);
    

    c2p = parula(noSim+2);
    c2p = c2p(idx,:);
        
    subplot(2,1,1)
        plot(it2p(1:pltSkp:end),i2p.tab(1:pltSkp:end),sym2plt{idx},'Color',c2p,'linewidth',2)
        ylabel('{\tau_A}')
        title('Scenario external forcings')
        hold on
        ylim([0.2 0.31])
    subplot(2,1,2)
        plot(it2p(1:pltSkp:end),i2p.eta_climb(1:pltSkp:end),sym2plt{idx},'Color',c2p,'linewidth',2)
        ylabel('{r}')
        xlabel('Deposode fraction')
        hold on
        ylim([-0.2 5.2].*(1E-5))
   legend({'Scenario 3','Scenario 2','Scenario 1'})
   
end


%% Figure 1: Dynamic dune scales 


figure('position',[0 0 800 800])
noIC = 12
aVal = 0.2;
sym2plt = {':','-.','--'};


for idx = noSim:-1:1%:noSim
    
    
     anonFun = @(x,y)(nanmean(x));
     dH = unvelopeArray(sim(idx).res,'duneHeightsInt','duneHeightsInt',anonFun);
     dW = unvelopeArray(sim(idx).res,'WaveLen','WaveLen',anonFun);
     dC = unvelopeArray(sim(idx).res,'duneCrestsInt','duneCrestsInt',anonFun);
     dT = unvelopeArray(sim(idx).res,'duneTroughsInt','duneTroughsInt',anonFun);
     anonFun = @(x,y)(nanstd(x));
     dHstd = unvelopeArray(sim(idx).res,'duneHeightsInt','duneHeightsInt',anonFun);

    c2p = parula(noSim+2);
    c2p = c2p(idx,:);
   
        
   subplot(2,2,1) %plot bedform height
       hold on
       plot(inputs.t2p./inputs.nt,mean(dH),sym2plt{idx},'color',c2p,'linewidth',2)
       xlabel('Time - deposode fraction')
       box on
       title('Dune height')

    subplot(2,2,2)%plot bedform wavelgnth  
        hold on
        plot(inputs.t2p./inputs.nt,mean(dW),sym2plt{idx},'color',c2p,'linewidth',2)
        xlabel('Time - deposode fraction')
        box on
        title('Dune wavelength')

   subplot(2,2,3)%plot crest and trough elevations
        dc2p = mean(dC);
        dt2p = -mean(dT);
        plot(inputs.t2p./inputs.nt,dc2p - dc2p(1),sym2plt{idx},'color',c2p,'linewidth',2)
        hold on
        plot(inputs.t2p./inputs.nt,dt2p - dt2p(1),sym2plt{idx},'color',c2p,'linewidth',2)
        axis tight
        title('Dune crest and trough elevation')
        xlabel('Time - deposode fraction')
        box on

    subplot(2,2,4)%plot crest and trough elevations standard deviation
        hold on
        plot(inputs.t2p./inputs.nt,nanmean(dHstd),sym2plt{idx},'color',c2p,'linewidth',2)
        title('Dune crest and trough elevation std')
        xlabel('Time - deposode fraction')
        box on
end


%% Figure 8: dune count, surface count, surfaces per dune count

figure('position',[0 0 600 1000])
noIC = 12;
aVal = 0.4;

sym2plt = {':','--','-'};

for idx = noSim:-1:1

    anonFun = @(x,y)(nanmean(x));
    nD = unvelopeArray(sim(idx).res,'noDunes','noDunes',anonFun);

    anonFun = @(x,y)(nanmean(x));
    nS = unvelopeArray(sim(idx).res,'noSets','noSets',anonFun);

    c2p = parula(noSim+2);
    c2p = c2p(idx,:);

    subplot(3,1,1)
        pltUnvelope(inputs.t2p./inputs.nt,nD,aVal,c2p)
        hold on
        plot(inputs.t2p./inputs.nt,mean(nD),sym2plt{idx},'color',c2p,'linewidth',2)
        axis tight
        box on
        title('Number of Dunes')
    subplot(3,1,2)
        pltUnvelope(inputs.t2p./inputs.nt,nS,aVal,c2p)
        hold on
        plot(inputs.t2p./inputs.nt,mean(nS),sym2plt{idx},'color',c2p,'linewidth',2)
        axis tight
        box on
        title('Number of Surfaces')
    subplot(3,1,3)
        pltUnvelope(inputs.t2p./inputs.nt,nS./nD,aVal,c2p)
        hold on
        plot(inputs.t2p./inputs.nt,mean(nS./nD),sym2plt{idx},'color',c2p,'linewidth',2)
        axis tight
        ylim([0 0.5])
        box on
        title('#surfaces/#dunes')
        xlabel('Time - deposode fraction')

end
%% Figure 8 INSET: dune count, surface count, surfaces per dune count

figure('position',[0 0 200 600])
noIC = 12;
aVal = 0.4;

sym2plt = {':','--','-'};


for idx = noSim:-1:1%:noSim

anonFun = @(x,y)(nanmean(x));
nD = unvelopeArray(sim(idx).res,'noDunes','noDunes',anonFun);

anonFun = @(x,y)(nanmean(x));
nS = unvelopeArray(sim(idx).res,'noSets','noSets',anonFun);

c2p = parula(noSim+2);
c2p = c2p(idx,:);

subplot(3,1,1)
    pltUnvelope(inputs.t2p./inputs.nt,nD,aVal,c2p)
    hold on
    plot(inputs.t2p./inputs.nt,mean(nD),sym2plt{idx},'color',c2p,'linewidth',2)
    axis tight
    box on
%     title('Number of Dunes')
    xlim([0 0.2])
subplot(3,1,2)
    pltUnvelope(inputs.t2p./inputs.nt,nS,aVal,c2p)
    hold on
    plot(inputs.t2p./inputs.nt,mean(nS),sym2plt{idx},'color',c2p,'linewidth',2)
    axis tight
    box on
%     title('Number of Surfaces')
    xlim([0 0.2])
subplot(3,1,3)
    pltUnvelope(inputs.t2p./inputs.nt,nS./nD,aVal,c2p)
    hold on
    plot(inputs.t2p./inputs.nt,mean(nS./nD),sym2plt{idx},'color',c2p,'linewidth',2)
    axis tight
%     ylim([0 0.85])
    box on
%     title('#surfaces/#dunes')
    xlabel('Time - deposode fraction')
    xlim([0 0.2])

end


%% Figure 9: set thickness, bedform height CoV, perservation ratio

figure('position',[0 0 600 1000])
aVal = 0.4;



for idx = noSim:-1:1%:noSim
    
    anonFun = @(x,y)(gammaCov(x));
    gCov = unvelopeArray(sim(idx).res,'duneHeights','duneHeights',anonFun);
    anonFun = @(x,y)(expMean(y(y>minSetThickness))./gammaMean(x));
    omega = unvelopeArray(sim(idx).res,'duneHeights','setThickness',anonFun);
    anonFun = @(x,y)(expMean(x(x>minSetThickness)));
    eMean = unvelopeArray(sim(idx).res,'setThickness','setThickness',anonFun);
    
    c2p = parula(noSim+2);
    c2p = c2p(idx,:);

    %bedform topo CoV
    subplot(3,1,1)
        pltUnvelope(inputs.t2p./inputs.nt,gCov,aVal,c2p)
        hold on
        loglog(inputs.t2p./inputs.nt,mean(gCov),sym2plt{idx},'color',c2p,'linewidth',2)
        hold on
        set(gca,'yscale','log')
        axis tight
        box on
        title('CoV dune topography')
    subplot(3,1,2)
        set(gca,'yscale','log')
        pltUnvelope(inputs.t2p./inputs.nt,eMean,aVal,c2p)
        hold on
        semilogy(inputs.t2p./inputs.nt,mean(eMean),sym2plt{idx},'color',c2p,'linewidth',2)
        hold on
        axis tight
        ylim([0 2])
        box on
        title('Mean set thickness')
    subplot(3,1,3)
        set(gca,'yscale','log')
        pltUnvelope(inputs.t2p./inputs.nt,omega,aVal,c2p)
        hold on
        semilogy(inputs.t2p./inputs.nt,mean(omega),sym2plt{idx},'color',c2p,'linewidth',2)
        hold on
        box on
        axis tight
        ylim([0 1])
        title('Preservation ratio')
        xlabel('Time - deposode fraction')

end

%% Figure 10: omega vs. CV with interpolated time

figure('position',[1000 0 600 400])
%  interpLine(cellfun(@mean,setThickness)./cellfun(@mean,duneHeights),cellfun(@std,duneHeights)./cellfun(@mean,duneHeights),t2p)

sym2plt = {':','--','-'};
aVal = 0.2;
noIC = 12;

minCV = 1;
maxCV = 1;


 for idx = noSim:-1:1%:noSim

    c2p = parula(noSim+2);
    c2p = c2p(idx,:);

    anonFun = @(x,y)((expMean(y(y>minSetThickness))./gammaMean(x)));
    omega = unvelopeArray(sim(idx).res,'duneHeights','setThickness',anonFun);
    anonFun = @(x,y)(gammaCov(x));
    cv2 = unvelopeArray(sim(idx).res,'duneHeights','duneHeights',anonFun);
    cv2 = cv2.^2;

    hold on

    interpLine(mean(cv2),mean(omega),inputs.t2p./inputs.nt,2,sym2plt{idx});
    minCV = nanmin(nanmin(mean(cv2)),minCV);    
    maxCV = nanmax(nanmax(mean(cv2)),maxCV);

    
    drawnow

    
    set(gca,'yscale','log')
    set(gca,'xscale','log')

    

 end
ylabel('{\omega}')
xlabel('CV')

xtp = linspace(minCV-0.05,maxCV+0.05);
 plot(xtp,0.8225*xtp,'k','linewidth',2)
xlim([0.009 1.1])
ylim([0.005 1.01])







%% SUPER BONUS unpublished figure: shredded vs. preserved time

figure('position',[100 100 800 800])

for idx = noSim:-1:1%:noSim

    sT = sim2cell(sim(idx).res,'stratTime',length(inputs.idx2smp),noIC);
    tT = sim2cell(sim(idx).res,'surfTime',length(inputs.idx2smp),noIC);
    c2p = parula(noSim+2);
    c2p = c2p(idx,:);
    timeRatio = cellfun(@(x,y)(mean(x(:))./mean(y(:))),sT,tT);
    evenFun = @(x,y)(nanmean(x(:))/nanmean(y(:)));
    unvelopeStruct(inputs.t2p./inputs.nt,sim(idx).res,'stratTime','surfTime',evenFun,aVal,c2p)
    plot(inputs.t2p./inputs.nt,timeRatio,sym2plt{idx},'linewidth',2,'Color',c2p)
    hold on
    set(gca,'yscale','log')
    set(gca,'xscale','log')
    box on
    xlim([min(inputs.t2p./inputs.nt)+eps max(inputs.t2p./inputs.nt)])

end
title('Total preserved time within stratigraphic sections')
xlabel('Total time - deposode fraction')
ylabel('Preserved time - deposode fraction')
% axis equal

