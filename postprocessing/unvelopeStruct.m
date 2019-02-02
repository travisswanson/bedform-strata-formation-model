function h = unvelopeStruct(x,S,fn1,fn2,anonFun,falpha,cVal)
% quick function to plot a nicely shaded UNvelope

u = zeros(length(S),size(getfield(S,{1},fn1),2));

%perform calculation on each IC to make coordindates for unvelope
for idx = 1:length(S) %loop over IC
    t1 = getfield(S,{idx},fn1); %get cells for first quantity
    t2 = getfield(S,{idx},fn2); %get cells for second quantity
    tRes = cellfun(@(t1,t2)anonFun(t1,t2),t1,t2); %make calculation for each cell
    %collect all in cells per sample interval for percentile calculations
    u(idx,:) = tRes;
end

yH = zeros(1,size(u,2));
yL = zeros(size(yH));

for idx = 1:size(u,2)
    yH(idx) = prctile(u(:,idx),90);
    yL(idx) = prctile(u(:,idx),10);
end

%     yH = cellfun(@(x)prctile(x(:),90),y);
%     yL = cellfun(@(x)prctile(x(:),10),y);
    
    xVar = [x fliplr(x)];
    yVar = [yL fliplr(yH)];

%      C = waterColors(cIdx);
% %     C = parula(cIdx);
    xVar(xVar<eps) = eps;
    yVar(yVar<eps) = eps;
    
    liNan = isnan(xVar) | isnan(yVar);
    xVar(liNan) = [];
    yVar(liNan) = [];
    
 h = patch(xVar,yVar,cVal,'EdgeColor','None','FaceAlpha',falpha);