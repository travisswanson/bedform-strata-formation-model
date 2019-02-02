function u = unvelopeArray(S,fn1,fn2,anonFun)
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

