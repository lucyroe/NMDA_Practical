%% performs preprocessing & analysis of tactile perceptual bistability fMRI
% fMRI data was obtained at the Neurocognitive Methods and Data Analysis
% Practical class at Freie University Berlin on 16th and 17th October 2023

%% SETUP -----------------------------------------------------------------

runs = {'1', '2', '3', '4', '5', '6'};  % runs
subj = {'001'}; % subjects
cond = {'simultaneous', 'alternating'}; % conditions

scriptpath = fullfile('/Users/Lucy/Documents/GitHub/NMDA_Practical');   
% change to where the scripts are for you
datapath = fullfile(['/Users/Lucy/Documents/Berlin/FU/MCNB/' ...
    '3Semester/NMDA_Practical/data']);  % change to where data is for you
spmpath = fullfile('/Users/Lucy/Documents/MATLAB/spm12');  
% change to where you downloaded the spm toolbox
addpath(scriptpath, datapath, spmpath)   % add script, data and spm path

steps = {'1', '2', '3', '4', '5'};    % analysis steps to be performed
%   1:   Preprocessing
%   2:   Localizer Analysis
%   3:   First Level Analysis - Contrasts Alternating / Simultaneous
%   4:   Decoding
%   5:   Group Level Analysis

spm('defaults', 'FMRI');    % setup spm
spm_jobman('initcfg');  % initialize spm

% initialise fMRI analysis process loop over subjects
for sub_no=1:len(subj)
    sub = subj{sub_no};

    % loop over the desired analysis steps
    for step_no=1:len(steps)
        step = steps{step_no};

        if step == '1'
        %% STEP 1: PREPROCESSING ------------------------------------------
            % REALIGNMENT (motion correction) of epi images
            % prefix "r"
            
            % CO-REGISTRATION puts t1 and (mean) epi image in the same 
            % space
            
            % SEGMENTATION of the t1 image into white and grey matter
            % output: deformation field
            
            % NORMALISATION uses deformation field to normalize epi images 
            % into MNE space
            % prefix "w"
            
            % SMOOTHING
            % prefix "s"
            
        elseif step == '2' 
        %% STEP 1: LOCALIZER ANALYSIS ------------------------------------
            
            % ********************** DATA FORMATTING *********************
            % extract onsets of different conditions (alt/stim/baseline) 
            % from localizer log file
            
    
        elseif step == '3'
        %% STEP 2: FIRST LEVEL ANALYSIS - CONTRASTS ALT/SIM --------------
            
            % ********************** DATA FORMATTING *********************
            % extract onsets & durations of blocks / switches (from alt to 
            % stim and vice versa) from run log file for each run

            for run=1:n_runs
            
            end
    
        elseif step == '4'
        %% (STEP 3: DECODING) --------------------------------------------
            
        elseif step == '5'
        %% (STEP 4: GROUP LEVEL ANALYSIS) --------------------------------

        end
    end
end