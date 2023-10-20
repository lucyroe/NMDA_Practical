%% read in log files and create variable

% Function name:    read_logfile
% Description:      read in logfile and create variable to be able to
%                   access onsets, durations and conditions
% Arguments:        logfile (needs to be in .txt format)   
% Outputs:          a log_variable with the attributes, accessible by dot
%                   indexing
%
%                   for runs
%                       TrialNr     :   number of trial
%                       onset       :   onset of stimulus cue
%                       condition   :   condition (-1: switch to
%                                       alternating; 1: switch to 
%                                       simultaneous)
%                       duration    :   duration of block
%                       offsetA     :   start of subjective perception of
%                                       alternating after objective onset 
%                                       (subjective onset = onset +
%                                       offsetA)
%                       offsetS     :   start of subjective perception of
%                                       simultaneous after objective onset 
%                                       (subjective onset = onset +
%                                       offsetS)
%
%                   for localizer
%                       TrialNr     :   number of trial
%                       onset       :   onset of stimulation
%                       condition   :   condition (1: left stimulation; 2:
%                                       right stimulation; 3: baseline 
%                                       = no stimulation)


function [log_variable] = read_logfile(logfile)
    log_variable = readtable(logfile);
end
