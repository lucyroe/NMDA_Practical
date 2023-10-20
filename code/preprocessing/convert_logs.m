% deciper log files: localizer! bicep!

task = 1; % 0 = localizer, 1 = bicep
subjects = {'001'}; % subjects
sourceF = '/Users/Lucy/Documents/Berlin/FU/MCNB/3Semester/NMDA_Practical/data';

if task == 0
    
    for subject_number = 1:length(subjects)
        subject = subjects{subject_number};
        subject_datapath = fullfile(sourceF, sprintf('sub-%s', subject));
        cd(subject_datapath);
    
        logs = dir('log_sub*_localizer*');
    
        for r = 1:size(logs)
        
            load(logs(r).name);
            conds = log.conditions;
            ons = log.onset;
            indices = ([1:size(conds,2)]*2)-1;
            onsets = ons(indices);
        
            new_log = [[1:size(conds,2)]'...
                        onsets'...
                        conds'];
            new_log_C = arrayfun(@num2str,new_log,'UniformOutput',false);
            logfile_datapath = fullfile(subject_datapath, 'log_files');
            fileID = fopen([logfile_datapath '/log_sub-' ...
                subject '_localizer.tsv'],'w');       
            % creates the empty logfile in the directory you specify

            formatSpec2 = '%s\t%s\t%s\n';  
            % it only works like this as the header format
            labels = ["TrialNr" "onset" "condition"];   % specifies 
            % labels for each column that should be in the logfile
            fprintf(fileID, formatSpec2, labels);   % this actually prints
            % the line labels into the first row of the log file.
            for f = 1:size(conds,2)
                fprintf(fileID, formatSpec2, new_log_C{f,:});
            end
            fclose(fileID); 
        
        end
    end

elseif task == 1

    behav = readtable(fullfile(sourceF, 'BTAPE-Group-Data.csv'));
    
    for subject_number = 1:length(subjects)
        subject = subjects{subject_number};
        subject_datapath = fullfile(sourceF, sprintf('sub-%s', subject));
        cd(subject_datapath);
    
        logs = dir('log*_run*');
    
        for r = 1:size(logs)
        
            load(logs(r).name);
            dif = [-1 diff(log.cueseries)];
            ons = log.onsets;
            indices = find(dif);
            conds = dif(indices);
            onsets = ons(indices);
            duration = diff([indices, length(ons)])*0.8;
            offsetA = repelem(table2array(behav(subject_number, 4+r)), ...
                size(onsets,2));
            offsetS = repelem(table2array(behav(subject_number, 10+r)), ...
                size(onsets,2));
        
            new_log = [[1:size(onsets,2)]'...
                        onsets'...
                        conds' ...
                        duration'...
                        offsetA'...
                        offsetS'];
            new_log_C = arrayfun(@num2str,new_log,'UniformOutput',false);
            
            logfile_datapath = fullfile(subject_datapath, 'log_files');
            fileID2 = fopen([logfile_datapath '/log_sub-' ...
                subject '_run-' num2str(r) '.tsv'],'w');       
            % creates the empty logfile in the directory you specify

            formatSpec2 = '%s\t%s\t%s\t%s\t%s\t%s\n';  
            % it only works like this as the header format
            labels = ["TrialNr" "onset" "condition" "duration" ...
                "offsetA" "offsetS"];     % specifies labels for each 
            % column that should be in the logfile
            fprintf(fileID2, formatSpec2, labels);  % this actually prints 
            % the line labels into the first row of the log file.
            for f = 1:size(conds,2)
                fprintf(fileID2, formatSpec2, new_log_C{f,:});
            end
            fclose(fileID2); 
        
        end
    end

end
