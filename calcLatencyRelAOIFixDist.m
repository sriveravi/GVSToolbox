% get latency until relevant AOI fixated
% 
% Syntax: latency =calcLatencyRelAOIFix( eyePos, aoiCenter, maxDist, AOIsOfInterest ) 
% 
% Inputs:
%  eyePos: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%         missing data.  They are in range [ 0 ,1 ]
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  maxDist: returned by  'returnAOICenters.m'
%  AOIsOfInterest: index of AOIs which we are interested in
% 
% Outputs:
%  latency: value between 0 and length of eye track, 
% 

function latency =calcLatencyRelAOIFixDist( fixStruct, aoiCenter, maxDist, AOIsOfInterest ) 


fixPosVector = fixStruct.fixPosVector;
fixationVector = fixStruct.fixationVector;


% % % initialize some paramters
% % fixationWinSize = 6;
% % fixationThreshold = 15;
% % 
% % % scale eye tracks(using default value ), calculate fixations
% % [ eyePos ] = scaleEyeTrack( eyePos,  [] ); 
% % [ fixationVector P ]  = codeFixations( eyePos, fixationWinSize, fixationThreshold );


numFixation = size(fixPosVector,2);
numSamples = length( fixationVector );
latency = numSamples;

for i1 = 1:numFixation  
    dist = calc2Dist( fixPosVector(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist && sum(minIdx == AOIsOfInterest)
         latency = find(  fixationVector == i1 );
         latency = latency(1); %/numSamples; % look at beginning of fixation
         break;
    end       

end



    

