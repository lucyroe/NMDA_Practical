%% data formatting / duration extraction

% Function name:    extract_durations
% Description:      extracts duration values of log files and puts them into 
%                   a vector
% Arguments:        vector with onsets of switches           
% Outputs:          one vector with the duration of each condition
%                   (alternating or simultaneous)

function [duration_values] = extract_durations(onsets)
        duration_values = cell(2, 1); % initiate empty cell 
        % array to fill with duration values for different conditions
        
        for line=1:size(onsets,1)
            % first line is switch to alternating, second line is switch to
            % simultaneous
            condition_onsets = onsets{line};
            duration_values_condition = [];
            for onset_index=1:length(condition_onsets)
                onset = condition_onsets(onset_index);
                if line == 1
                    if onset > onsets{line+1}(onset_index)
                        duration = onset - onsets{line+1}...
                            (onset_index);
                    else
                        duration = onsets{line+1}(onset_index) ...
                            - onset;
                    end
                    duration_values_condition = [duration_values_condition ...
                        duration];
                else
                    if onset > onsets{line-1}(onset_index)
                        duration = onset - onsets{line-1}...
                            (onset_index);
                    else
                        duration = onsets{line-1}(onset_index) ...
                            - onset;
                    end
                    duration_values_condition = [duration_values_condition ...
                        duration];
                end
                duration_values{line,1} = duration_values_condition;
            end

        end