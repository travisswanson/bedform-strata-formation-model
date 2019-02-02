function [mWaveLen,mHeight,mTrough,mCrest]=mScales(Z,inputs,idx2smp)
%function to calculate average values of bedform scales for the indices
%used for plotting.

    mWaveLen = zeros(size(idx2smp));
    mHeight = zeros(size(idx2smp));
    mTrough = zeros(size(idx2smp));
    mCrest = zeros(size(idx2smp));
    
    ic = 1;
    
    for jdx = 1:length(idx2smp)

        idx = idx2smp(jdx);
        z = Z(idx,:);

        [pks,plocs] = findpeaks(z);
        mWaveLen(ic) = nanmean(diff(plocs))*inputs.dx;

        [tks,~] = findpeaks(-z);

        tks = -tks;

        mTrough(ic) = nanmean(tks);
        mCrest(ic) = nanmean(pks);
        mHeight(ic) = mCrest(ic) - (mTrough(ic));
        
        ic = ic + 1;


    end
end