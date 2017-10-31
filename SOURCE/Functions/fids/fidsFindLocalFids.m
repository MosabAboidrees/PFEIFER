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


function values = fidsFindLocalFids(TSindex,type,fidset)
% FUNCTION values = fidsFindLocalFids(TSindex,type,[fidset])
% OR       values = fidsFindLocalFids(TSdata,type,[fidset])
%
% DESCRIPTION
% Find local fiducials in a time series
%
% INPUT
% TSindex       The index into the TS cell array that contains the data
% TSdata        A struct or cell-array containing the data
% type          The type of fiducial
% fidset        The fidset to search in
%
% OUTPUT
% value         A [1xm] vector for global fiducials or a [nxm] matrix in
%               case local fiducials are defined as well
%
% SEE ALSO fidsType


%%%% deal with different inputs and load 'fids'
fids = [];
fidset = {};
values = [];


if isstruct(TSindex)
    if isfield(TSindex,'fids'), fids  = TSindex.fids; end
    if isfield(TSindex,'fidset'), fidset = TSindex.fidset; end
end


if isnumeric(TSindex)
    global TS;
    if isfield(TS{TSindex},'fids'), fids  = TS{TSindex}.fids; end
    if isfield(TS{TSindex},'fidset'), fidset = TS{TSindex}.fidset; end
end

%%%% fids is now ts.fids 

if isempty(fids), return; end


%%%%  make type the 'fids - number'
if ischar(type), type = fidsType(type); end




localf = [];

for p=1:length(fids)
    if (nargin == 3)
        if ((fids(p).type ~= type)||(fids(p).fidset ~= fidset))
            continue;
        end
    else
        if (fids(p).type ~= type)
            continue;
        end
    end
    
    
    if length(fids(p).value) ~= 1
        localf(1:length(fids(p).value),end+1) = reshape(fids(p).value,length(fids(p).value),1);
    end
end

values = localf;

return