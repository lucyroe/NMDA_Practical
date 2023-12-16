%% Brain Slice Plot 
clear
close all

scriptpath = fullfile('/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/code/');
% change to where the scripts are for you
datapath = fullfile('/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/analysis/2nd_level/');
resultspath = fullfile('/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/analysis/');
spmpath = fullfile('/Users/Lucy/Documents/MATLAB/spm12/'); 
BrainSlicerpath = fullfile('/Users/Lucy/Documents/MATLAB/brainslicer/');
% change to where you downloaded the spm toolbox
addpath(scriptpath, ...
    datapath, resultspath, spmpath, BrainSlicerpath)  % add script, data and spm path; 

% Also, close open figures, if any:
%close all

% Localizer Figure - all subjects

 slicer({2,fullfile(datapath, 'left', 'rspmT_0002.nii')},...
    'limits',{[],[0.25 1], },...
    'minClusterSize',{0,50},...
    'colormaps',{1,2},...
    'labels',{[],'Localizer Left'},... % when a layer's label is empty no colorbar will be printed.
    'cbLocation','south',... % colorbar location can be south or east
    'title','Left Localizer (p<0.01 unc.)',...
    'colorMode', 'w',...
    'skip', [0.35 0.35],...
    'view', 'ax',...
    'coordinateLocation', 'sw',...
    'mount', [6 1],... % print one row with 8 slices equally spaced    
    'margins', [0.3 0.3 0.05 0],...
    'fontsize', [11 6 6],...
    'output','Localizer_Left_axial')
 
slicer({5,fullfile(datapath, 'right', 'rspmT_0001.nii'), },...
    'limits',{[],[0.25 1]},...
    'minClusterSize',{0,50},...
    'colormaps',{1,3},...
    'labels',{[],'Localizer Right'},... % when a layer's label is empty no colorbar will be printed.
    'cbLocation','south',... % colorbar location can be south or east
    'title','Right Localizer (p<0.01 unc.)',...
    'colorMode', 'w',...
    'skip', [0.35 0.35],...
    'view', 'cor',...
    'coordinateLocation', 'sw',...
    'mount', [6 1],... % print one row with 8 slices equally spaced    
    'margins', [0.3 0.3 0.05 0],...
    'fontsize', [11 6 6],...
    'output','Localizer_Right')

 slicerCollage('wildcard', 'slicer_Localizer_*', ...
                'output','Localizer_Fig_allsubs')