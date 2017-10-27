function TSmapindex = fidsIntegralMap(TSmapindex,TSindices,startframe,endframe,average)

% FUNCTION TSmapindex = fidsIntegralMap(TSmapindex,TSindices,startframe,endframe,['average'])
% OR       TSmapdata  = fidsIntegralMap(TSmapdata,TSdata,startframe,endframe,['average'])
%
% DESCRIPTION
% This function adds integralmaps at the end of a TS-structure that already contains some
% integral-maps or creates a new one.
%
% INPUT
% TSmapindex        An index into the TS-array, pointing to the TS-structure where the
%                   maps have to be stored (could be an empty initialised TS-structure)
% TSindices         Indices into the TS-array of the time data that needs to be integrated
% TSmapdata         Similar to TSmapindex, but now the data is directly put on the input
% TSdata            Similar to TSindices, but now the data is directly put on the input
% startframe        frame number of where to start the integration
% endframe          frame number of where to end the integration
%
% OUTPUT
% TSmapindex
%   /TSmapdata      Output of the adjusted data 
%
%

global aaa
if aaa, xxx = endframe, end

if nargin == 4
    average = 0;
end

if nargin == 5
    if ischar(average), average = 1; else, average = 0; end 
end

global TS;

numleads = 0;
label = '';
filename = '';

if ~isempty(TSmapindex)
    numleads = TS{TSmapindex}.numleads;
    leadinfo = TS{TSmapindex}.leadinfo;
    unit = TS{TSmapindex}.unit;
    label = TS{TSmapindex}.label;
    filename = TS{TSmapindex}.filename;
else
    TSmapindex = tsInitNew(1);
    TS{TSmapindex}.newfileext =  '-itg';
end

% Find the numleads in each of the TSindices

if numleads == 0
    numleads = TS{TSindices(1)}.numleads;
    unit = TS{TSindices(1)}.unit;
    label = TS{TSindices(1)}.label;
    filename = TS{TSindices(1)}.filename;  
    leadinfo = zeros(numleads,1);
    if average == 0
        unit = [unit 'ms'];
    end
end



% Startframe to bring the data in a better format


if length(startframe) == numel(startframe)
    if length(startframe) == 1
        startframe = startframe*ones(1,length(TSindices));
    end
    if length(startframe) == length(TSindices)
        startframe = reshape(startframe,1,length(TSindices));
    end
    if size(startframe,2) == 1
        startframe = startframe*ones(1,length(TSindices));
    end
    if size(startframe,1) == 1
        startframe = ones(numleads,1)*startframe;
    end
end
    
if (size(startframe,1) ~= numleads)||(size(startframe,2) ~= length(TSindices))
    error('startframe has not the right dimensions\n');
end

if aaa, xxx2 = endframe, end
if length(endframe) == numel(endframe)
    if length(endframe) == 1
        endframe = endframe*ones(1,length(TSindices));
    end
    if length(endframe) == length(TSindices)
        endframe = reshape(endframe,1,length(TSindices));
    end
    if size(endframe,2) == 1
        endframe = endframe*ones(1,length(TSindices));
    end
    if size(endframe,1) == 1
        endframe = ones(numleads,1)*endframe;
    end
end

if aaa, xxx3 = endframe, end
    
if (size(endframe,1) ~= numleads)||(size(endframe,2) ~= length(TSindices))
    error('endframe has not the right dimensions\n');
end


startframe = round(startframe);
endframe = round(endframe);

if aaa, xxx4 = endframe, end

% Finally start with the integration

map = zeros(numleads,length(TSindices));
audit = '';

for p = 1:length(TSindices)
    audit = [audit sprintf('|AddIntegralMap( file=%s, start=%d, end=%d)',TS{TSindices(p)}.filename,startframe(1,p),endframe(1,p))];
    for q=1:numleads
        idx=startframe(q,p):endframe(q,p);
        x=TS{TSindices(p)}.potvals(q,idx);         
        map(q,p) = sum(x);
        leadinfo(q) = leadinfo(q) & TS{TSindices(p)}.leadinfo(q);
    end
    if average == 1
        len = endframe(:,p)-startframe(:,p);
        map(:,p) = map(:,p)./len;
    end
end
    



TS{TSmapindex}.potvals = [TS{TSmapindex}.potvals map];
TS{TSmapindex}.numframes = size(TS{TSmapindex}.potvals,2);
TS{TSmapindex}.numleads = size(TS{TSmapindex}.potvals,1);
TS{TSmapindex}.unit = unit;
TS{TSmapindex}.leadinfo = leadinfo;
TS{TSmapindex}.audit  = [TS{TSmapindex}.audit audit];
TS{TSmapindex}.label = label;
TS{TSmapindex}.filename = filename;    









        