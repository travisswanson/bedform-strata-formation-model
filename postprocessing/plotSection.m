function plotSection(Z,x,inputs,smpInterval)
%function to plot a stratigraphic section
% Z = topographic surfaces
% x = horizontal distances for each column in x
% inputs = input structure
% smpInterval = time sampling (rows)interval of Z

    %topography 2 stratigraphy
    Z = topo2strat(Z);

    %plot a section, colormaped by depositional time
    section(Z(1:smpInterval:end,:),[],x,smpInterval,inputs);
end