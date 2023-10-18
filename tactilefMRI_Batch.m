%% SETUP -----------------------------------------------------------------

n_runs = 6; % number of runs
n_subj = 1; % number of subjects
n_cond = 2; % number of conditions

steps = 1:4;    % analysis steps to be performed
%   1:   Localizer Analysis
%   2:   First Level Analysis - Contrasts Alternating / Simultaneous
%   3:   Decoding
%   4:   Group Level Analysis

% *************************** DCM IMPORT *********************************


for step=1:len(steps)
    %% STEP 1: LOCALIZER ANALYSIS ----------------------------------------
    
    % ********************** DATA FORMATTING *****************************
    % extract onsets of different conditions (alt/stim/baseline) from 
    % localizer log file
    
    % ************************ PREPROCESSING *****************************
    % REALIGNMENT (motion correction) of epi images
    % prefix "r"
    
    % CO-REGISTRATION puts t1 and (mean) epi image in the same space
    
    % SEGMENTATION of the t1 image into white and grey matter
    % output: deformation field
    
    % NORMALISATION uses deformation field to normalize epi images into MNE
    % space
    % prefix "w"
    
    % SMOOTHING
    % prefix "s"
    
    
    %% STEP 2: FIRST LEVEL ANALYSIS - CONTRASTS ALT/SIM ------------------
    
    % ********************** DATA FORMATTING *****************************
    % extract onsets & durations of blocks / switches (from alt to stim and
    % vice versa) from run log file for each run
    for run=1:n_runs
    
    end
    
    %% (STEP 3: DECODING) ------------------------------------------------
    
    
    %% (STEP 4: GROUP LEVEL ANALYSIS) ------------------------------------
end