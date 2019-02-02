function [hlyr,hsrf]=section(Z,F,x,smpInt,inputs)
%function to make a section using
% Z stratigraphic elevations (2D array)
% F facies (2D array)
% smpInt (scalar) time interval between stratigraphic surfaces in Z
% inputs (input structure from input_creator)

    [nz,nx]=size(Z);
    nt=nz-1;

    % by default cell property = time
    if(nargin<2 || isempty(F))
        F=repmat(((1:nt).*(smpInt/inputs.nt))',[1,nx-1]); 
    end

    % by default x = pixels 
    if(nargin<3)
        x=1:nx;
    end

    % plot layers
    hlyr=surf(x,Z,0*Z,F);
    shading flat;
    view(0,90);
    grid off;

    % plot surfaces
    hold on;
    hsrf=plot(x,Z','k');
    hold off;
    axis tight;

end
