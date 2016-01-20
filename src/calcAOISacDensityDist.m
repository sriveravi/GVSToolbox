% calculate target saccade density
% 
% Syntax: AOIDensity =calcAOISacDensity( eyePos, aoiCenter, maxDist ) 
% 
% Inputs:
%  eyePos: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%         missing data.  They are in range [ 0 ,1 ]
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
% 
% Outputs:
%  AOIDensity: vector of number of saccades to a particular AOI

function [AOIDensity ] =calcAOISacDensityDist( sacStruct, aoiCenter, maxDist ) 


endSacPos = sacStruct.endSacPos;

%calculate AOI fixation density
numAOI = size(aoiCenter,2);
numSaccades = size( endSacPos,2);
AOIDensity = zeros( numAOI,1);
effectivNumSaccades = 0;

for i1 = 1:numSaccades  
    dist = calc2Dist( endSacPos(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist 
        effectivNumSaccades = effectivNumSaccades+1;
        AOIDensity(minIdx) = AOIDensity(minIdx) + 1;
    end       
end

% normalize so the sum is 1
if effectivNumSaccades > 0
    AOIDensity = AOIDensity./sum( AOIDensity);
end


