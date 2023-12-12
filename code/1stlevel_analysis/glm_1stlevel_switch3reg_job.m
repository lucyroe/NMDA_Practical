%% FIRST LEVEL GLM SWITCH ONLY

% Function name: glm_1stlevel_switch_job
% Description: This script runs a first-level glm (only) over all 6 runs
% with three regressors
% Arguments: files with smoothed data,
%            log files with onsets
%            epoch duration
%            regressors 
%            motion parameters
%            contrasts
%            outputdir

% ALLES NOCH ANPASSEN!!!

function glm_1stlevel_switch3reg_job(datapath_nifti, runs, run_logs, conditions_runs, contrastvec1, outputfolder_1stlevel_switch3reg)

clear matlabbatch

smoothed_imgpaths = cell(length(runs), 1);

matlabbatch{1}.spm.stats.fmri_spec.dir = {outputfolder_1stlevel_switch3reg};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;


% loop over runs  

for s = 1:length(runs)

    f_run_number = sprintf('%02d', s);
    switch_dir = fullfile(datapath_nifti, ['run', f_run_number]);

    smoothed_path = cellstr(spm_select('FPList', switch_dir, '^sw.*\.nii$'));
    smoothed_imgpaths{s} = cellfun(@(path) [path, ',1'], smoothed_path, 'UniformOutput', false);

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).scans = smoothed_imgpaths{s};

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).name = conditions_runs{2};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).onset = (run_logs{1,s}.onset(run_logs{1,s}.condition == 1)/1000);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).duration = run_logs{1,s}.duration(run_logs{1,s}.condition == 1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).name = conditions_runs{1};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).onset = (run_logs{1,s}.onset(run_logs{1,s}.condition == -1)/1000);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).duration = run_logs{1,s}.duration(run_logs{1,s}.condition == -1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).name = 'switch_sim';
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).onset = (run_logs{1,s}.onset(run_logs{1,s}.condition == 1)/1000);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).duration = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).name = 'switch_alt';
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).onset = (run_logs{1,s}.onset(run_logs{1,s}.condition == -1)/1000);
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).duration = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).orth = 1;

    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = cellstr(spm_select('FPList', switch_dir,'^rp_.*\.txt$'));
    matlabbatch{1}.spm.stats.fmri_spec.sess(s).hpf = 128;

end

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

% MODEL ESTIMATION
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% CONTRAST MANAGER 
matlabbatch{3}.spm.stats.con.spmmat = {[outputfolder_1stlevel_switch3reg filesep 'SPM.mat']};

matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = conditions_runs{2};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = contrastvec1{1}; % phase sim
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = conditions_runs{1};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = contrastvec1{2}; % phase alt
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'switch_oneregressor';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = contrastvec1{3}; % switch 
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

% Stats

%{
matlabbatch{4}.spm.stats.results.spmmat = {[outputfolder_1stlevel_switch4reg filesep 'SPM.mat']};
matlabbatch{4}.spm.stats.results.conspec(1).titlestr = conditions_runs{2};
matlabbatch{4}.spm.stats.results.conspec(1).contrasts = {ADD}; % ERROR
matlabbatch{4}.spm.stats.results.conspec(1).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(1).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(1).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(1).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(2).titlestr = conditions_runs{1};
matlabbatch{4}.spm.stats.results.conspec(2).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(2).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(2).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(2).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(2).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(3).titlestr = 'switch_sim';
matlabbatch{4}.spm.stats.results.conspec(3).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(3).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(3).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(3).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(3).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(3).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(4).titlestr = 'switch_alt';
matlabbatch{4}.spm.stats.results.conspec(4).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(4).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(4).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(4).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(4).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(4).mask.none = 1;
%}


% Create job 
fprintf('Computing 1st Level GLM\n')
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch)

clear matlabbatch 


