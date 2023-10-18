%% performs preprocessing & analysis of tactile perceptual bistability fMRI
% fMRI data was obtained at the Neurocognitive Methods and Data Analysis
% Practical class at Freie University Berlin on 16th and 17th October 2023

%% SETUP -----------------------------------------------------------------

runs = {'1', '2', '3', '4', '5', '6'};  % runs
subjects = {'001'}; % subjects
conditions_runs = {'alternating', 'simulatenous'};  % conditions in the runs
conditions_localizer = {'left_stimulation', 'right_stimulation', ...
    'baseline'};  % conditions in the localizer

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
for sub_number=1:length(subjects)
    subject = subjects{sub_number};
    subject_datapath = fullfile(datapath, sprintf('sub-%s', subject));
    cd(subject_datapath);

    % list logfiles for that subject
    logPattern = sprintf('log_sub-%s*', subject)';
    fileList = dir(logPattern);

    % separate localizer and run logfiles
    localizer_logfile = {};
    runs_logfiles = {};
    for i = 1:length(fileList)
        fileName = fileList(i).name;

        % Check if the file name starts with your desired prefix
        if startsWith(fileName, sprintf('log_sub-%s localizer', subject)) 
            % localizer logfile
            localizer_logfile = string(fileName);
        elseif startsWith(fileName, sprintf('log_sub-%s_run', subject))
            % run logfile
            runs_logfiles = [runs_logfiles, {string(fileName)}];
        end
    end

    % loop over the desired analysis steps
    for step_number=1:length(steps)
        step = steps{step_number};

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

            load(localizer_logfile) % load localizer logfile

            % extract onsets using the function extract_onsets.m
            onsets_localizer_conditions = extract_onsets(log, ...
                conditions_localizer);

            % we now have a 3x1 cell array where the first cell has a 1x7
            % vector in it with the onset values of the first condition
            % (i.e., stimulation_left), the second cell of the second
            % condition and so on
    
        elseif step == '3'
        %% STEP 2: FIRST LEVEL ANALYSIS - CONTRASTS ALT/SIM --------------
            
            % ********************** DATA FORMATTING *********************
            % extract onsets & durations of blocks / switches (from alt to 
            % stim and vice versa) from run log file for each run

            % initiate empty array to fill with onsets and durations for
            % all runs
            onsets_durations_runs = cell(length(runs),2);

            for run_number=1:length(runs)
                % get corresponding logfile name
                run_logfile = runs_logfiles{run_number};
                % load logfile
                load(run_logfile)

                % extract onsets using the function extract_onsets.m
                onsets_run_conditions = extract_onsets(log, ...
                conditions_runs);

                % add onsets to big cell array
                onsets_duration_runs{run_number, 1} = onsets_run_conditions;

                % extract durations using the function extract_durations.m
                durations = extract_durations(onsets_run_conditions);
                % TO DO: fix extract_durations.m (doesn't work)

                % add durations to big cell array
                onsets_duration_runs{run_number, 2} = durations;
            end
    
        elseif step == '4'
        %% (STEP 3: DECODING) --------------------------------------------
            
        elseif step == '5'
        %% (STEP 4: GROUP LEVEL ANALYSIS) --------------------------------

        end
    end
end