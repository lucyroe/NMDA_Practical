%% Behavioral analysis 

% set path
datapath = fullfile('/Users/denisekittelmann/Documents/MATLAB/BTAPE/data/');

% Read in behavioral data 

behavioral_data = readtable(fullfile(datapath, 'BTAPE-Group-Data.csv'));

% Convert table into matrix & reshape

behavioral_alt = behavioral_data{:, 5:10}; 
behavioral_sim = behavioral_data{:, 11:16}; 

aov_behavioral_matrix = vertcat(behavioral_alt, behavioral_sim);


% Perform a 2x6 ANOVA (WHAT ABOUT CHECKING THE NORMALITY ASSUMPTION?)

anova2(aov_behavioral_matrix, 9) % main effect of switch, i.e alt vs sim --> alt = easier


%% Descriptives

% Mean age
m_age = round(mean(behavioral_data.Age));

% Sex
[sexCounts, sexCategories] = histcounts(categorical(behavioral_data.Sex));
sexTable = table(sexCategories', sexCounts', 'VariableNames', {'Sex', 'Count'});

% Mean EDI
m_edi = round(mean(behavioral_data.EDI)); 

