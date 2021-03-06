% calculate fixation density at the AOIs
% 
% Syntax: [ AOIDensity effectivNumFixation]  = calcAOIFixDurationDist( fixStruct, aoiCenter, maxDist )
% 
% Inputs:
%  fixStruct: struct returned by codeFixations
%       fixStruct.fixDurVector: vector of (fx1),  for duration of fications
%       fixStruct.fixPosVector: in format [ x x x ... x; 
%                                                          y y y ... y]
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
% 
% Outputs:
%  AOIDensity: vector of number of time spent at particular AOI
%               the last entry is time outside of those AOIs


function [ AOIDensity effectivNumFixation]  = calcAOIFixDurationDist( fixStruct, aoiCenter, maxDist ) 


% fixationVector P
fixPosVector = fixStruct.fixPosVector;
fixDurVector = fixStruct.fixDurVector;

%calculate AOI fixation density
numAOI = size(aoiCenter,2);
numFixation = size( fixPosVector,2);
AOIDensity = zeros( numAOI+1,1);
effectivNumFixation = 0;

for i1 = 1:numFixation  
    dist = calc2Dist( fixPosVector(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist 
        effectivNumFixation = effectivNumFixation+1;
        AOIDensity(minIdx) = AOIDensity(minIdx) + fixDurVector(i1);
    else
        AOIDensity( end) =  AOIDensity( end) + fixDurVector(i1);
    end
end


