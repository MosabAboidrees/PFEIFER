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


function newTSindices = tsSliceTS(TSindices,fstart,fend)
% FUNCTION [newTSindices] = tsSliceTS(TSindices,fstart,fend)
%          [newTSindices] = tsSliceTS(TSindices,[fstart:fend])
%          newdata = tsSliceTS(data,fstart,fend) 
%          newdata = tsSliceTS(data,[fstart:fend]) 
%
% DESCRIPTION
% This function takes a subset of the slices from the data. It works in various modes: 1)
% supplying indices in the TS array will do the operation in the TS array, 2) if you request
% an output argument new entries will be made in the TS array with the sliced data, 3) You can
% supply the timeseries data directly and get back the data directly. 
%
% INPUT
% TSindices/data   You can provide the data directly or as indices of the TS array
% fstart           Frame to start with
% fend             Frame to end with
%
% OUTPUT 
% newTSindices     In case there is an output argument a new data set will be created
%                  with the sliced data, otherwise the original TS series will be sliced
% newdata          In case of providing the data directly the sliced data will be put on
%                  the output
%   
% SEE ALSO tsSplitTS

if nargin == 2
    fend = fstart(end);
    fstart = fstart(1);
end

global TS;
if nargout == 1
    newTSindices = tsNew(length(TSindices));
    for p=1:length(TSindices)
        TS{newTSindices(p)} = TS{TSindices(p)};  
    end
    TSindices = newTSindices;
end

for p=1:length(TSindices)
    if nargin == 1
        if isfield(TS{TSindices(p)},'selframes')
            frames = TS{TSindices(p)}.selframes;
            fstart = frames(1);
            fend   = frames(end);
        else
            fstart = 1;
            fend = TS{TSindices(p)}.numframes;
        end
    end

    numframes = fend(1)-fstart(1)+1;
    numleads = size(TS{TSindices(p)}.potvals,1);
    data = zeros(numleads,numframes);
    for q=1:length(fstart)
        data = data+TS{TSindices(p)}.potvals(:,fstart(q):fend(q));
    end
    if length(fstart) > 1, data = data*(1/length(fstart)); end

    TS{TSindices(p)}.potvals = data;
    TS{TSindices(p)}.numframes = numframes;
    audit = [sprintf('|sigSlice Slice/Average data, startframe: ') sprintf('%d ',fstart) 'endframe: ' sprintf('%d ',fend)];
    TS{TSindices(p)}.audit = [TS{TSindices(p)}.audit audit];

    if isfield(TS{TSindices(p)},'fids')
        fids = TS{TSindices(p)}.fids;
        keep = [];
        for q=1:length(fids)
            if and((fids(q).value >= fstart(1)),(fids(q).value <= fend(1)))
                keep = [keep q];
                fids(q).value = fids(q).value - fstart(1)+1;
            end
        end
        TS{TSindices(p)}.fids = fids(keep);
    end


end


newTSindices = TSindices;


