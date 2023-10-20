%% data formatting / onset extraction

% Function name:    extract_onsets
% Description:      extracts onset values of log files and puts them into 
%                   a vector
% Arguments:        logfile
%                   list of conditions                
% Outputs:          one vector with onset values for each condition
%                   depending on the list of conditions, these vectors will
%                   be named onsets_condition

function [onset_values] = extract_onsets(logfile, conditions)
        onset_values = cell(length(conditions), 1); % initiate empty cell 
        % array to fill with onset values for different conditions

        for condition_number=1:length(conditions)

            if length(conditions) == 2 % logfile of  the runs 
                % (conditions: alternating vs. simultaneous)

                % find indeces of the elements where there was a switch
                % from one condition to another
                index_switches_to_sim = [];
                index_switches_to_alt = [];
                for index_cue=1:length(logfile.cueseries)
                    if index_cue == 449
                        break
                    end
                    if logfile.cueseries(1,index_cue+1) < ...
                            logfile.cueseries(1,index_cue)  % switch from 
                        % alternating to simultaneous
                        index_switches_to_sim = [index_switches_to_sim ...
                            index_cue+1];
                    elseif logfile.cueseries(1,index_cue+1) > ...
                            logfile.cueseries(1,index_cue)  % switch from 
                        % simultaneous to alternating
                        index_switches_to_alt = [index_switches_to_alt ...
                            index_cue+1];
                    else
                        continue
                    end
                end

                % use this index to access elements in the vector
                % with the onsets of that switch
                onsets_to_sim = logfile.onsets(index_switches_to_sim);
                onsets_to_alt = logfile.onsets(index_switches_to_alt);

                % add the onsets of this condition to our cell array with
                % the onsets of all conditions
                onset_values{1,1} = onsets_to_sim;
                onset_values{2,1} = onsets_to_alt;
                break

            else    % logfile of the localizer
                % (conditions: stimulation_left vs. stimulation_right vs.
                % baseline)

                % first we need to remove every second element of the
                % localizer logfile as there was a break of 800ms after
                % each 800ms

                % create a logical index for elements to keep
                keepIndex = mod(1:length(logfile.onset), 2) == 1;

                % use the logical index to extract the elements to keep
                new_onsets = logfile.onset(keepIndex);

                % create a logical index for elements in the vector with 
                % the conditions that match the condition
                logical_index = (logfile.conditions == condition_number);
                
                % use this logical index to access elements in the vector
                % with the onsets of that condition
                condition_onsets = new_onsets(logical_index);

                % add the onsets of this condition to our cell array with
                % the onsets of all conditions
                onset_values{condition_number,1} = condition_onsets;

            end

        end
end
