% calculate the total distance traveled by the eye
% 
% Syntax: distTraveled =calcDistTraveled( eyePos ) 
% 
% Inputs:
%  eyePos: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%         missing data.  They are in range [ 0 ,1 ]
% 
% Outputs:
%  distTraveled: total euclidean distance traveled

function distTraveled =calcDistTraveled( eyePos ) 

numSamples = length( eyePos );
eyePos =  [ real( eyePos(:)) imag(eyePos(:)) ]'; % in [ x x ... x; y y ... y ]
dist = zeros( 1, numSamples);

% remove when missing
isMissing = find(eyePos(1,:) == -1);
isMissing = unique([ isMissing isMissing+1 ]);
isMissing( isMissing == numSamples) = [];

for i1 = 2:(numSamples)
    dist(i1) = calc2Dist( eyePos(:,i1-1), eyePos(:,i1));    
end
dist(isMissing) = 0;




    
distTraveled = sum(dist);
    