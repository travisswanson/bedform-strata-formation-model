function [R] = fastPost(Zs,inputs,itcnt,sim_num,idx2smp)
% fastPost - calculate bedform wavelength, height, celerity, peak and
% trough elevation through time, for sampled intervals of time.


    %declare structure and fields for saving postprocessing resutls
	R.noDunes = {[]};
	R.noSets = {[]};
	R.firstStep = {[]};
	R.duneHeights = {[]};
	R.duneTroughs = {[]};
	R.duneCrests = {[]};


	R.duneHeightsInt = {[]};
	R.duneTroughsInt = {[]};
	R.duneCrestsInt = {[]};


	R.setThickness = {[]};
	R.stratTime = {[]};
	R.surfTime = {[]};


	[row,col] = size(Zs);

	%iteration counter for storage
	ic = 1;

	%loop to calculate set thickness through time
	 for kdx = 1:length(idx2smp)

		k = idx2smp(kdx);%end-timestep of sample
		timeVec = 1:k;
		
		%create kth timestep stratigraphy
		Z = topo2strat(Zs(1:k,:));
		Li = Z == Zs(1:k,:);
		Li_bs = logical_bounding_surface(Li,size(Z,1));
		[~, c] = max( Li ~=0, [], 1 ); %this finds the first timestep to become stratigraphy
		
		nstc = zeros(1,size(Z,2)); %number of sets
		stc = {[]}; %set thicknesses
		sfT = zeros(1,col);
		stT = zeros(1,col);
		
		
		%number of sets and set thickness for each node
		for i = 1:size(Z,2) %for each grid node
			sttp = Z(Li_bs(:,i),i); %find bounding surface elevatios
			bsElev = sttp(1:2:(end-2));
			stp = diff(bsElev); % this removes the set from the modern bedform
			stc{i} = stp(stp>0); % set thicknesses (non-uniform number)
			nstc(i) = numel(stc{i}); % number of sets per node
			
			%total time of strat and surfaces
			stT(i) = sum(Li(:,i)'.*timeVec>0).*inputs.dt; %preserved time
			sfT(i) = sum((~Li(:,i))'.*timeVec>0).*inputs.dt; %shreaded time

		end
		
		emtST = cellfun(@isempty,stc); %find empty set thickness cells
		stc(emtST) = [];
		
		R.setThickness{ic} = cat(1,stc{:}); % this records the set thicknesses for each investigation interval
		R.firstStep{ic}= c; % this records the first preserved strata for each column of Zs
		R.noSets{ic} = nstc;

		R.stratTime{ic} = stT;
		R.surfTime{ic} = sfT;
		ic = ic + 1;
		
		fprintf('SN: %i IC: %i Fast post I : %f \n',sim_num,itcnt,k/(inputs.nt*inputs.np));

	 end

	%find all peaks, troughs, bedform heights along domain

	%save entire nodes geometry
	htc = {[]}; %height
	ctc = {[]}; %crests
	ttc = {[]}; %trough

	%save time of geometry
	geoTime = {[]};


	% loop through space, parse in time later!
	 for j = 1:col
		%only consider topography from first bounding surface, onward. 
		Zsmp = Zs(:,j);
		[pks, plocs]=findpeaks(Zsmp);
		[tks, tlocs]=findpeaks(-Zsmp);
		%logical index to make vectors same length
		li = 1:min(numel(tlocs),numel(plocs));

		%save entire nodes geometry
		htc{j} = pks(li) + tks(li); 
		ctc{j} = pks(li);
		ttc{j} = tks(li);
		
		%save time of geometry (choose to average times of peaks and troughs)
		geoTime{j} = mean([plocs(li),tlocs(li)],2);

		fprintf('SN: %i IC: %i Fast post II : peak finding %f \n',sim_num,itcnt,j/col);
	 end
		 


	ic = 1;
		
	%find values at set time intervals
	for kdx = 1:length(idx2smp)
		
		k = idx2smp(kdx);%index to sample
		
		%make logical index for dune geometry: first strata to k 
		fS = num2cell(R.firstStep{ic}); 
		
		%cellfun: each cell should be first strata to end of time interval
		hts = cellfun(@(x,y,fs)(x((y>=fs) & (y<=k))),htc,geoTime,fS,'uni',0); %dune heights
		cts = cellfun(@(x,y,fs)(x((y>=fs) & (y<=k))),ctc,geoTime,fS,'uni',0); %crest heights
		tts = cellfun(@(x,y,fs)(x((y>=fs) & (y<=k))),ttc,geoTime,fS,'uni',0); %trough heights
		
		%sample crest heights over an interval of time.
		if kdx == 1 % for the first interval
			htsInt = cellfun(@(x,y)(x(y<=k)),htc,geoTime,'uni',0); %dune heights
			ctsInt = cellfun(@(x,y)(x(y<=k)),ctc,geoTime,'uni',0); %crest heights
			ttsInt = cellfun(@(x,y)(x(y<=k)),ttc,geoTime,'uni',0); %trough heights
        else %this is for the remainder of sample intervals
			htsInt = cellfun(@(x,y)(x((y>=idx2smp(kdx-1)) & (y<=k))),htc,geoTime,'uni',0); %dune heights
			ctsInt = cellfun(@(x,y)(x((y>=idx2smp(kdx-1)) & (y<=k))),ctc,geoTime,'uni',0); %crest heights
			ttsInt = cellfun(@(x,y)(x((y>=idx2smp(kdx-1)) & (y<=k))),ttc,geoTime,'uni',0); %trough heights
		end
		
		ndtc = cellfun(@(x,y,fs)(numel(x((y>=fs) & (y<=k)))),htc,geoTime,fS); %number of dunes
		
		%Sampled intervals of dune scales into cells
		R.duneHeightsInt{ic} = cat(1,htsInt{:});
		R.duneCrestsInt{ic} = cat(1,ctsInt{:});
		R.duneTroughsInt{ic} = cat(1,ttsInt{:});

		%
		R.duneHeights{ic} = cat(1,hts{:});
		R.duneCrests{ic} = cat(1,cts{:});
		R.duneTroughs{ic} = cat(1,tts{:});

		R.noDunes{ic} = ndtc;
		
			
		ic = ic + 1;
		fprintf('SN: %i IC: %i Fast post II : sampling peaks %f \n',sim_num,itcnt,k/(inputs.nt*inputs.np)); 
	end
end