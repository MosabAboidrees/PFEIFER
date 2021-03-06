% MIT License
% 
% Copyright (c) 2017 The Scientific Computing and Imaging Institute
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.



function setupToolSelectionDropdownmenus(figObj)
global SCRIPTDATA
[pathToPFEIFERfile,~,~] = fileparts(which('PFEIFER.m'));   % find path to PFEIFER.m

%%%% hardcoded lists of the tags of the dropdown menus and the folders corresponding to them
dropdownTags = {    'FILTER_SELECTION', 'BASELINE_SELECTION',   'ACT_SELECTION', 'REC_SELECTION'};     % the Tags of the dropdown uicontrol objects
toolsFoldernames = {'temporal_filters', 'baseline_corrections', 'act_detection', 'rec_detection'};    % these are the folder names of the folder in the TOOLS folder
toolsOptions = {    'FILTER_OPTIONS',   'BASELINE_OPTIONS',     'ACT_OPTIONS',   'REC_OPTIONS'};


%%%% loop through dropdown menus:
for p=1:length(dropdownTags)

    %%%% find the dropdown object
    dropdownObj = findobj(allchild(figObj),'Tag',dropdownTags{p});
    
    %%%% get the path to tools folder
    pathToTools = fullfile(pathToPFEIFERfile,'TOOLS',toolsFoldernames{p});
    
    %%%% get all the function.m names in that folder. these are the different options to choose from
    folderData = what(pathToTools);
    functionNames = folderData.m;
    % get rid of the '.m' at the end
    for q=1:length(functionNames)
        functionNames{q} = functionNames{q}(1:end-2);
    end
    
    
    %%%% set the dropdownObj.String
    if isempty(functionNames)
        [dropdownObj.String] = deal('no function found');
    else
        [dropdownObj.String] = deal(functionNames);      % deal and [  ] necessary here, because in case of 'BASELINE_SELECTION', there are two objects (since there are select baseline dropdown menus with the same tag)
    end
    
    %%%% set the dropdownObj.Value
    if SCRIPTDATA.(dropdownTags{p}) > length(functionNames)
        SCRIPTDATA.(dropdownTags{p}) = 1;
    end
    [dropdownObj.Value] = deal(SCRIPTDATA.(dropdownTags{p}));     % deal and [ ... ] necessary here, because in case of 'BASELINE_SELECTION', there are two objects (since both select baseline dropdown menus have that same tag)
    
    %%%% save the toolsOptions in SCRIPTDATA (for later use)
    SCRIPTDATA.(toolsOptions{p}) = functionNames;
end
    

end