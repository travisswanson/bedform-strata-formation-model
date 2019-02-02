function inputs = input_creator(sim_num)
%function to create inputs structure for a given simulation (1,2,3)

	%model grid set-up
	inputs.l_x = 10000; %total length of domain
	inputs.dx = 10;  %unit distance between nodes	
	inputs.x = 0:inputs.dx:inputs.l_x; % grid
    
    %Aeolian surface model parameters
	inputs.tc = tand(32); %angle of repose
	inputs.A = 0.1; % flow blocking parameter
	inputs.B = 3; % flow shoaling parameter
	inputs.Dg = 0.2; %diffusivity (this is over-written later on)
	inputs.m = 1; % sediment flux coeff.
	inputs.n = 1.5; % sediment flux exp. (bed load)
	inputs.p = 0.4; % porosity
	inputs.dt = 1; % time step
	inputs.E = 20; % avalanche diffusivity

	%initial topography
	inputs.eta_i =  0.01*rand(1,length(inputs.x));
	inputs.eta = inputs.eta_i(1,:);

    %periodic boundary conditions
    inputs.x_index = 1:length(inputs.eta);
    inputs.x_p1_index = [2:length(inputs.eta) 1];
    inputs.x_m1_index = [length(inputs.eta) 1:length(inputs.eta)-1];

	%background climb rate
    inputs.bk_eta_climb = 5e-05;
	
    %simulation time control = 3 deposodes
	inputs.np = 3; % number of deposodes (sedimentation cycles)
	inputs.nt = 25000; % number of time steps per deposode
    
    %create sampling vector
    %Time steps to sample and model time to plot
    earlySmp = 100; %number of early-time samples to collect
    lateSmp = 100; %number of late-time samples to collect
    minIdx1 = 100; %earliest early time
    MaxIdx1 = 5000; %oldest early time
    minIdx2 = 5100; %earlierst late time
    MaxIdx2 = inputs.nt*inputs.np; %oldest late time (total simulation duration)

    %create vector of sampling indexs
    inputs.idx2smp = [ceil(linspace(minIdx1,MaxIdx1,earlySmp)) ceil(linspace(minIdx2,MaxIdx2,lateSmp))];
    inputs.t2p =(inputs.idx2smp).*inputs.dt; % simulation time to plot

    %time-varying transport capacity and agradation rate configuration
	at = 0.3; %maximum amplitude of variable boundary shear stress runs
	const_shear = at*ones(1,inputs.nt); %boundary shear stress if constant
	const_climb = (inputs.bk_eta_climb/2)*ones(1,inputs.nt); % climb rate if constant
	%anon function for time varying shear stress
	var_shear = @(x,at,nt) (at*x)/2*sin((1:nt)*pi*2/nt) + at*(1-x)+(at*x)/2;
	%no climb at all (still need input!)
	no_climb = zeros(1,inputs.nt);

	%these are the three scenarios
	switch sim_num
		case 1
			 %0% climn 0% shear
			inputs.tab = const_shear;
			inputs.eta_climb = no_climb;
		case 2
			%20%climb, 20% variable shear (HIGH CASE)
		   inputs.tab = var_shear(0.2,at,inputs.nt);
		   inputs.eta_climb = const_climb;%var_climb(1,dr,nt);
		case 3
			%constant climb, constant shear
			inputs.tab =  const_shear;
			inputs.eta_climb = const_climb;
	end
end
 
 
 
 
