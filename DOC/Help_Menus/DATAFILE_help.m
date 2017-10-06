%% myProcessingScript
% in a Processing Data File PFEIFER stores all the settings/user selections
% that are file specific, eg. fiducials, start/endframe or information
% about the baseline correction. 
% 
%% explanation
%
% * When PFEIFER is started, it looks for a 'ProcessingData.mat' file in the
% current folder. If it finds one, all the settings from that file are
% imported. Any changes the user makes will also be saved in that file
% (overwriting previous user selections). If there is no
% 'ProcessingData.mat' file in the current folder at the start of PFEIFER,
% PFEIFER creates one and saves all future file specific user selections in
% that created file.
% * Whenever the path in the Processing Data File text bar is changed,
% PFEIFER looks if the file specified by the path exists. If it does, all the file
% specific settings from that file are imported and future user selections
% saved in that file. If it doesn't, PFEIFER creates a file at the specified
% path and from that point on uses that file as a Processing Data File.
%
%% notes
%
% * PFEIFER links the chosen file specific user selections to the
% corresponding data input files (eg. .ac2 files) by their file name. Thus,
% if the filenames are changed, PFEIFER cannot link the chosen settings to
% the rigth file anymore.
