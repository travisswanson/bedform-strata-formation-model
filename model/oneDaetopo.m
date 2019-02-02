function etas = oneDaetopo(inputs,eta,itcnt,sim_num) 
%this code runs the 1D aeolian surface model of
%Swanson, T., Mohrig, D., Kocurek, G., and Liang, M., 2017, A Surface Model for Aeolian Dune Topography: Mathematical Geosciences, v. 49, p. 635-655, doi: 10.1007/s11004-016-9654-x.
% inputs = input structure from input_creator
% eta = initial condition of bed topography
% itcnt = initial condition number (of 12)
% sim_num = simulation number (of 3)

        
    %preallocate for saving time steps of topography, eta
    %into an array called... etas.
    etas = zeros(inputs.nt*inputs.np,length(inputs.x_index));

    ic = 1;%counter for saving eta into etas
    meta = 0; %total aggradation added to bed during simulation

    for i = 1:inputs.np % deposode loop

        for j = 1:inputs.nt % number of time steps PER sedimentation cycle
            %shear stress for eta with a mean value of zero.
            tx = inputs.tab(j).*(1+(inputs.A.*(eta-meta))+inputs.B.*((eta(inputs.x_index)-eta(inputs.x_m1_index))./inputs.dx));
            %lee shadow zone
            tx(tx<0) = 0;
            %upwind x avalanching flag
            avhCrit_uwx = (eta(inputs.x_index)-eta(inputs.x_p1_index))./inputs.dx; 
            %avalanching flux
            qa_x = 20*(avhCrit_uwx.^2 - inputs.tc^2).*avhCrit_uwx.*((avhCrit_uwx) > inputs.tc);
            %local sediment flux
            q =  inputs.m*(tx).^inputs.n + qa_x; %+ rand(1,length(inputs.x));
            %qacomp = (-inputs.dt/((1-inputs.p)*inputs.dx)).*(qa_x(inputs.x_index)-qa_x(inputs.x_m1_index));
            %dq
            xcomp = q(inputs.x_index)-q(inputs.x_m1_index);
            %dq/dx
            a_eta = (-inputs.dt/((1-inputs.p)*inputs.dx)).*(xcomp);
            %D*d^2eta/dx^2
            d_eta = (inputs.dt*inputs.Dg/(inputs.dx^2)).*((eta(inputs.x_p1_index)+eta(inputs.x_m1_index) - 2.*eta(inputs.x_index)));
            %new eta = old eta + change in eta;
            eta= eta + a_eta + d_eta;
           
            %add sediment to bed and track bed aggradation
            eta = eta + inputs.eta_climb(j); %add sediment to bed (uniform)
            meta = meta + inputs.eta_climb(j); %track the amount of sediment added to bed, so it can be subtracted from the shear stress calculation

            %save eta
            etas(ic,:) = eta;
            ic = ic + 1; %because the number of deposodes could vary, we need a different iteraction tracker

            %let the poor worker know that the code is still running
            if mod(j,10000) == 0
                fprintf('SN: %i IC: %i  Topography running\n',sim_num,itcnt);
            end

        end %time per sedimentation cycle
    end % number of sedimentation cycles
end