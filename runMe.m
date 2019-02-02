%Script to re-create figures from:

%Swanson, T., D. Mohrig, G. Kocurek, B. Cardenas, M. Wolinksy, 
%in preparation for Journal of Sedimentary Research, 
%Preservation of autogenic processes and allogenic forcings within
%set-scale aeolian architecture I: numerical experiments

%instructions:
%Press F5 (windows) or save-and-run (green play button) within the Matlab
%Editor. The scripts will print out updates within the Command Window. Each
%cell below generates results, or figures. Read the comments within each
%cell (below) to determine what to run to generate which figure within the
%manuscript

% For help, please contact: Travis Swanson, travis.swanson@gmail.com
% Look for software updates at https://tswanson.net/bedform-strata-formation-model/
% and general research updates at www.tswanson.net

%% create paths

%generate paths; this may not work on OS X / Linux
[filepath,name,ext] = fileparts(mfilename('fullpath'));
wkPth = genpath(filepath); % 
addpath(wkPth);  %in case of failure, just add all paths in the directory that contains this file

%% Generate results and post-process simulations (1,2,3) 
%This will take no less than 25 minutes and approximately 16gb 
%of system memory if you have the Parallel Computing Toolbox.
%Serial computation is supported (of course), but has not been tested.

if license('test','distrib_computing_toolbox')
    runSimulationsParallel
else %run the simulatiosn one at a time (unknown duration)
    runSimulationsSerial
end

%% All stratigraphic section plots (Figs. 2, 3, 4, 5, 6, and 7)
%Note: this cell does not require 'runSimulationsParallel' or
%'runSimulationsSerial' to have been run. 

stratigraphicSectionPlots

%% topographic/stratigraphic analysis plots (Figs. 1, 8, 9, 10)
%Note: This cell requires 'runSimulationsParallel' or
%'runSimulationsSerial' to have been run. 

scatterPlots

%% Make movies of topographic/stratigraphic co-evolution
%Note: this cell does not require 'runSimulationsParallel' or
%'runSimulationsSerial' to have been run. 

%Note uncomment or remove the '%' infront of "makeMovies" to run the script
%to make the videos of the three simulations.

makeMovies