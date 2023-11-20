%-----------------------------------------------------------------------
% Job saved on 20-Nov-2023 13:49:13 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\Users\45040\Documents\MATLAB\ana_test\Practical\2nd_level_switch'};

path_to_contrasts = uigetdir(pwd, "C:\Users\45040\Documents\MATLAB\ana_test\Practical\2nd_level_switch")
contrast_images = dir(fullfile(path_to_contrasts, '*.nii'));
%%
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {contrast_images                                                          };
%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;



matlabbatch{1}.spm.stats.fmri_est.spmmat = {matlabbatch{1,1}.spm};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;


matlabbatch{1}.spm.stats.con.spmmat = {matlabbatch{1,1}.spm};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'contrast_name';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 0;

