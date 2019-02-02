function [mWaveLen,mHeight,mTrough,mCrest]=mScalesCell(Z,inputs,idx2smp)
%function to calculate average values of bedform scales for the indices
%used for plotting.

    mWaveLen = {[]};
    mHeight = {[]};
    mTrough = {[]};
    mCrest = {[]};
    
    ic = 1;
    
    for jdx = 1:length(idx2smp)

        idx = idx2smp(jdx);
        z = Z(idx,:);

        [pks,plocs] = findpeaks(z);
        mWaveLen{ic} = nanmean(diff(plocs))*inputs.dx;

        [tks,tlocs] = findpeaks(-z);

        tks = -tks;

        mTrough{ic} = tks;
        mCrest{ic} = pks;
        
        tks = abs(tks);
        
        tks = tks(:);
        pks = pks(:);
        
         if (isempty(pks) || isempty(tks))
            
             mHeight(ic) = [];
         
         else
             %if there are the same number of troughs and crests
            if numel(pks) == numel(tks)
                if plocs(1) < tlocs(1) % peak first
                   mHeight{jdx} = pks + npks;
                else % a trough is first!
                   mHeight{jdx} = [(pks(1:end-1) + tks(2:end)); (pks(end) + tks(1))];
                end
            else % if there are fewer one than the other
                
                li = 1:min(numel(pks),numel(tks));
                
                tlocs = tlocs(li);
                plocs = plocs(li);
                
                if plocs(1) < tlocs(1) % peak first
                   mHeight{jdx} = pks + npks;
                else % a trough is first!
                   mHeight{jdx} = [(pks(1:end-1) + tks(2:end)); (pks(end) + tks(1))];
                end
                
            end
        end
            
        ic = ic + 1;

    end
end