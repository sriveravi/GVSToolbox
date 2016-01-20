% Calculate fixation density for different distances from relevant AOIs
% 
% Syntax: histMatrix =calcAOIFixDistHist( eyePos, aoiCenter, numBins, AOIsOfInterest ) 
% 
% Inputs:
%  eyePos: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%         missing data.  They are in range [ 0 ,1 ]
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  numBins: number of bins to split up distance histogram
%  AOIsOfInterest: index of AOIs which we are interested in
% 
% Outputs:
%  histMatrix: histogram of distances to all the AOIs, each column
%       contains all fixation distance from to corresponding column of  aoiCenter. 
%       The elements in column are repeated accordint time fixation time
% 

function histMatrix =calcAOIFixDistHistDist( fixStruct, aoiCenter, numBins, AOIsOfInterest, imRange ) 

fixPosVector = fixStruct.fixPosVector;
fixDurVector = fixStruct.fixDurVector;

if nargin < 5 || isempty(imRange)
    imRange = [1024; 1280];
end

% initialize some things
numAOI = size(aoiCenter,2);
numFixation = size( fixPosVector,2);
distCell = cell( numFixation,1);
if nargin < 4 || isempty(AOIsOfInterest)
    AOIsOfInterest = 1:numAOI;
end
if nargin < 3 || isempty(numBins)
    numBins = 10;
end
histMatrix = zeros( numBins, length(AOIsOfInterest));
xHist=linspace(0, imRange(2), numBins);

%calculate histogram of fixation distances
k1 = 1;
for i1 = AOIsOfInterest(:)'
    distTemp = calc2Dist( aoiCenter(:,i1), fixPosVector); % 2-norm 
    for i2 = 1:numFixation;
        distCell{i2} = repmat(distTemp(i2), [fixDurVector(i2) ,1]);
    end
    distValuesTemp = cell2mat(distCell); 
    n = hist(  distValuesTemp, xHist);
    if sum(n)>0
        histMatrix(:,k1)= n./sum(n);
    end
    k1 = k1+1;
    
%     % show it
%     bar( xHist,histMatrix(:,k1));
%     pause(.5);
    
end
    

