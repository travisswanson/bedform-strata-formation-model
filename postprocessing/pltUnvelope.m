function h = pltUnvelope(x,y,falpha,cVal)
% quick function to plot a nicely shaded UNvelope

    yH = prctile(y,90);
    yL = prctile(y,10);
%     yH = max(y);
%     yL = min(y);
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