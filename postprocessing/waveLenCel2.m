function [mPeriod,WaveLen,Cel] = waveLenCel2(Z,idx2smp,dx,dt,method) 
%function to find wavelength and celerity uZing autocorrelation/distributed
%time warping. Although attractive, xcorr is an ineffective method for
%calculating celerity or wavelength, sigh, due to grid resolution.
%fft 
%dtw

if nargin == 1
    dx = 1;
    smpInv = 1;
    dt = 1;
    method = 'dtw';
end

[r,c] = size(Z);

smpIdx = length(idx2smp);

mWaveLen = zeros(1,smpIdx);
Cel = zeros(1,smpIdx);
mPeriod = zeros(1,smpIdx);
WaveLen = {[]};
% time loop
ic = 1;

for jdx = 1:length(idx2smp)
    idx = idx2smp(jdx);
    
    %find the dune wavelength for each timestep
%     [acor,~] = xcorr(Z(idx,:),'coeff');
%     [pks,locs] = findpeaks(acor);
%     mWaveLen(ic) = nanmean(diff(locs))*dx;
        [pks,locs] = findpeaks(Z(idx,:));
    mWaveLen(ic) = nanmean(diff(locs))*dx;
    wlt = diff(locs)*dx;
    WaveLen{ic} = wlt(:);
    
    %find the group wavelength for each timestep
%     [pklg,lclg] = findpeaks(acor,'MinPeakDistance',ceil(mWaveLen(ic))/dx,'MinPeakheight',0.2);
%      long = mean(diff(lclg))*dx
    
    %find the distance between two timesteps
    % sum of total warping/total distace = mean distance
    if idx < r
        switch method
            case 'xcorr'
                [acor,~] = xcorr(Z(idx,:),Z(idx+1,:),'coeff');
                [~,locs] = findpeaks(acor);
%                 plot(Z(idx,:))
%                 hold on
%                 plot(Z(idx+1,:))
                %widths of bedform movement
                Cel(ic+1)  = (nanmean(diff(locs))*dx)/dt;
            case 'dtw'
                delx = (dtw(Z(idx,:),Z(idx+1,:))/c)*dx;
                Cel(ic+1) = delx/dt; % the first Cel is zero.
        end
    end
    
    %find mean wavelength
    mPeriod(ic) = 1/meanfreq(Z(idx,:)',1/dx);
    
    ic = ic + 1;
end
    