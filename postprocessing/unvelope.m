function h = unvelope(x,y,falpha,cVal)
% quick function to plot a nicely shaded UNvelope

    yH = cellfun(@(x)prctile(x(:),90),y);
    yL = cellfun(@(x)prctile(x(:),10),y);
    
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