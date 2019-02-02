function scaledSection2(Z,x,inputs,smpInt,sTf,vEg,axisOffOrOn)
    %code to scale each bedform down to sTf% it's actual size... 
    %this prevents bedforms from looking like cactus needles.
  

if sTf < 1
    zend = Z(end,:);

    nx = length(zend);
    padLen = 100;
    idx = 1:(nx+2*padLen);

    %pad vector
    etafp = [zend((end-padLen+1):end) zend zend(1:padLen)];
    %find troughs
    [tks,loks] = findpeaks(-etafp);
    tks = -tks;
    
    if isempty(tks)
        warning('No troughs for scaling topography')
        return
    end

    %interpolate trough elevations
    lS = interp1(loks,tks,idx,'linear');
    %logical index for pad removal
    li = (idx > padLen) & (idx <= (nx+padLen));
    lS = lS(li);
    
    % reduce the height of the current node relative to the previous trough elevation
    Z(end,:) = sTf*(zend-lS) + lS;

end

%plot section
plotSection(Z,x,inputs,smpInt)
%change aspect ratio
daspect([1 vEg 1])

%axis ticks, or not?
if axisOffOrOn
    box on
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
else
    axis on
end
f = gcf;
f.Color = 'w';
