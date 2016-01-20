% calculate matrix representing the sequence of AOIs saccaded to
% 
% Syntax: [ AOISequence ] =calcAOISacSequence( eyePos, aoiCenter, maxDist, maxSaccades) 
% 
% Inputs:
%  sacStruct: returned from codeSaccadesDist
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
%  maxSaccades: number of saccades in the sequence to keep
% 
% Outputs:
%  AOISequence: matrix (numAOI x numFix) with an indicator (1) for
%       in each column corresponding to the AOI of interest.  If no
%       AOI, it will be an all 0;


function [ AOISequence ] =calcAOISacSequenceDist( sacStruct, aoiCenter, maxDist, maxSaccades ) 

% initialize some paramters
if nargin < 4 || isempty( maxSaccades )
    maxSaccades = 3;
end

% initialize some variables
endSacPos = sacStruct.endSacPos;
numAOI = size(aoiCenter,2);
numSaccades = size( endSacPos,2);
AOIOrderList = zeros(numSaccades,1); 
effectivNumSaccades = 0;

% find AOI fixation sequence
for i1 = 1:numSaccades  
    dist = calc2Dist( endSacPos(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist         
        effectivNumSaccades = effectivNumSaccades+1;        
        AOIOrderList(effectivNumSaccades) = minIdx;
    end
end

% code as a matrix of indicator variables
if effectivNumSaccades >0  
    AOISequence = zeros( numAOI, maxSaccades);     
    for i1 = 1:min(effectivNumSaccades, maxSaccades) 
        AOISequence(AOIOrderList(i1),i1) = 1; % indicator for AOI (1)
    end
    
else % all 0 if no relevant AOI
    AOISequence = zeros( numAOI,maxSaccades);
end




