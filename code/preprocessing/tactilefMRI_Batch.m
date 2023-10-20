%% performs preprocessing & analysis of tactile perceptual bistability fMRI
% fMRI data was obtained at the Neurocognitive Methods and Data Analysis
% Practical class at Freie University Berlin on 16th and 17th October 2023

%% SETUP -----------------------------------------------------------------

runs = {'01', '02', '03', '04', '05', '06'};  % runs
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

steps = {'2', '3'};
% '1', '2', '3', '4', '5'};    % analysis steps to be performed
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

    % loop over the desired analysis steps
    for step_number=1:length(steps)
        step = steps{step_number};

        if step == '1'
        %% STEP 1: PREPROCESSING ------------------------------------------
            % LOAD DATA
            datapath_nifti = fullfile(datapath, sprintf('sub-%s', ...
                subject), 'nifti_files');

            % loop over runs & localizer
            for run_number=1:length(runs)+1
                if run_number > length(runs)
                    run = 'localizer';
                    datapath_run = fullfile(datapath_nifti, run);
                else
                    run = runs{run_number};
                    datapath_run = fullfile(datapath_nifti, sprintf('run%s', ...
                    run));
                end
                cd(datapath_run)

                % list all nifti files
                nifti_list = dir('*.nii');

                functional_images = cell(360,1);
                for file=1:length(nifti_list)
                    functional_images{file} = fullfile(datapath_run, ...
                        nifti_list(file).name);
                end

                % REALIGNMENT (motion correction) of epi images
                % prefix "r"
                realigned_images = realign_job(functional_images);
                % this does not realign images as we need seperate cells
                % for each run in order for this to work (as each run is
                % realigned in relation to all the other runs)
                % TO DO: change this so we have one cell array with seven
                % cells for all runs (create separate run loop) and only
                % then realign all the images
                
                % CO-REGISTRATION puts t1 and (mean) epi image in the same 
                % space
                 structural_dir = fullfile(datapath_nifti, 'structural');
                cd(structural_dir)
                structural_image = fullfile(structural_dir, ...
                    dir('MFV*.nii').name); % load structural image
                cd(datapath_run)
                mean_functional_image = fullfile(datapath_run, ...
                    dir('mean*').name);  
                % select mean image from realignment
                coregistered_images = coregister_job( ...
                    mean_functional_image, structural_image);    
                % co-registrates the structural image with the
                % realigned functional image
                
                % SEGMENTATION of the t1 image into white and grey matter
                % output: deformation field
                cd(fullfile(spmpath, 'tpm'))

                tpm_file = fullfile(spmpath, 'tpm', dir('TPM*').name);
                % select tpm file
                s_img = segment_job(structural_image, tpm_file);  
                % segments the structural image    

                % NORMALISATION uses deformation field to normalize epi images 
                % into MNE space
                % prefix "w"
                cd(structural_dir)
                deformation_file = fullfile(structural_dir, dir( ...
                    'y*.nii').name);    % select deformation file

                cd(datapath_run)
                realigned_files_list = dir('r*.nii'); 
                % select realigned files
                realigned_files = cell(360,1);
                for file=1:length(realigned_files_list)
                    realigned_files{file} = fullfile(datapath_run, ...
                        realigned_files_list(file).name);
                end

                normalized_images = normalise_functional_job( ...
                    deformation_file, realigned_files); % normalize
                % realigned images
                
                % SMOOTHING
                % prefix "s"
                normalized_files_list = dir('wr*.nii'); 
                % select normalized files
                normalized_files = cell(360,1);
                for file=1:length(normalized_files_list)
                    normalized_files{file} = fullfile(datapath_run, ...
                        normalized_files_list(file).name);
                end

                smoothed_images = smooth_job(normalized_files); 
                % smoothes all images

            end
            
        elseif step == '2' 
        %% STEP 2: LOCALIZER ANALYSIS ------------------------------------
            
            % ********************** DATA LOADING ************************
            % read in logfiles for localizer
            
            localizer_log = read_logfile(fullfile(subject_datapath, ...
                'log_files', sprintf('log_sub-%s_localizer.txt', ...
                subject)));
    
        elseif step == '3'
        %% STEP 3: FIRST LEVEL ANALYSIS - CONTRASTS ALT/SIM --------------
            
            % ********************** DATA LOADING ************************
            % loop over runs and read in logfiles for runs
            run_logs = cell(1,4);
            for run_number=1:length(runs)
                run_log = read_logfile(fullfile(subject_datapath, ...
                'log_files', sprintf('log_sub-%s_run-%d.txt', ...
                subject, run_number)));
                run_logs{run_number} = run_log;
            end
            
    
        elseif step == '4'
        %% (STEP 4: DECODING) --------------------------------------------
            
        elseif step == '5'
        %% (STEP 5: GROUP LEVEL ANALYSIS) --------------------------------

        end
    end
end