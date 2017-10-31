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


function baseline_corrected_potvals = baselineCorrection(potvals,startframe,endframe,baselineWidth)
% start/endframe is either a number (global) or a vector (individual on a lead by lead basis)

[numleads, numframes] = size(potvals);


%%%% make sure start/endframe + baselineWidth are not out of index from potvals
e = ones(length(startframe),1);
startframe = median([e startframe e*(numframes-baselineWidth+1)],2);
endframe = median([e endframe e*(numframes-baselineWidth+1)],2);


idx = [(0:(baselineWidth-1))+startframe(1) endframe(1)+(0:(baselineWidth-1))];
if (nnz(startframe-startframe(1))==0) && (nnz(endframe-endframe(1))==0)
    X = ones(numleads,1)*idx;
    Y = potvals(:,idx);
else
    X = zeros(numleads,2*baselineWidth);
    Y = zeros(numleads,2*baselineWidth);
    for q=1:length(startframe)
        X(q,:) = [(0:(baselineWidth-1))+startframe(q) endframe(q)+(0:(baselineWidth-1))];
        Y(q,:) = potvals(q,X(q,:));  
    end
end

%%%% baseline correction
ymean = mean(Y,2);
xmean = mean(X,2);
Ymean = ymean*ones(1,length(idx));
Xmean = xmean*ones(1,length(idx));
B = sum(X.*(Y - Ymean),2)./sum((X-Xmean).^2,2);
A = ymean - B.*xmean;
e1 = 1:numframes;
e0 = ones(1,numframes);
Y = B*e1 + A*e0;
baseline_corrected_potvals = potvals - Y;
