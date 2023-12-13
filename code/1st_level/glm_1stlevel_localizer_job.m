%% FIRST LEVEL GLM LOCALIZER

% Function name: glm_1stlevel_localizer_job
% Description: This script runs a first-level glm (only) on the localizer runs.
% Arguments: files with smoothed data,
%            log files with onsets
%            epoch duration
%            regressors 
%            motion parameters
%            contrasts
%            outputdir
 
function glm_1stlevel_localizer_job(smoothed_imgpath, localizer_log, localizer_dir, epoduration, conditions_localizer, contrastvec, outputfolder_1stlevel_loc)

clear matlabbatch 

matlabbatch{1}.spm.stats.fmri_spec.dir = {outputfolder_1stlevel_loc};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

matlabbatch{1}.spm.stats.fmri_spec.sess.scans= smoothed_imgpath; 

% specify model parameters 
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = conditions_localizer{1};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = localizer_log.onset(localizer_log.condition == 1) / 1000;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = epoduration;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = conditions_localizer{2};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = localizer_log.onset(localizer_log.condition == 2) / 1000;  
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = epoduration;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = conditions_localizer{3};
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = localizer_log.onset(localizer_log.condition == 3) / 1000;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = epoduration;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''}; % multiple conditions
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {}); % regressors
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(spm_select('FPList', localizer_dir,'^rp_.*\.txt$')); % multiple regressors
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

% Model estimation {[outputfolder_1stlevel_loc filesep 'SPM.mat']}
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% Set contrasts 
matlabbatch{3}.spm.stats.con.spmmat = {[outputfolder_1stlevel_loc filesep 'SPM.mat']};

matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = conditions_localizer{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = contrastvec{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = conditions_localizer{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = contrastvec{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = conditions_localizer{3};
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = contrastvec{3};
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'left vs baseline';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = contrastvec{4};
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'right vs baseline';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = contrastvec{5};
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'left vs right';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = contrastvec{6};
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'right vs left';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = contrastvec{7};
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

% Stats
%{
matlabbatch{4}.spm.stats.results.spmmat = {[outputfolder_1stlevel_loc filesep 'SPM.mat']};
matlabbatch{4}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(1).contrasts = {ADD}; % ERROR HERE
matlabbatch{4}.spm.stats.results.conspec(1).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(1).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(1).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(1).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(2).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(2).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(2).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(2).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(2).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(3).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(3).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(3).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(3).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(3).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(3).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(3).mask.none = 1;


matlabbatch{4}.spm.stats.results.conspec(4).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(4).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(4).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(4).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(4).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(4).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(4).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(5).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(5).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(5).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(5).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(5).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(5).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(5).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(6).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(6).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(6).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(6).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(6).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(6).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(6).mask.none = 1;

matlabbatch{4}.spm.stats.results.conspec(7).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(7).contrasts = {ADD};
matlabbatch{4}.spm.stats.results.conspec(7).threshdesc = 'none';
matlabbatch{4}.spm.stats.results.conspec(7).thresh = 0.01;
matlabbatch{4}.spm.stats.results.conspec(7).extent = 50;
matlabbatch{4}.spm.stats.results.conspec(7).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(7).mask.none = 1;
matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.ps = true;

%}

% Create job 
fprintf('Computing 1st Level GLM\n')
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch)

clear matlabbatch 


