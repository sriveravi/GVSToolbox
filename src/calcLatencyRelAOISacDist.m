% get latency until relevant AOI is saccade target
% 
% Syntax: latency =calcLatencyRelAOISac( eyePos, aoiCenter, maxDist, AOIsOfInterest ) 
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

function latency =calcLatencyRelAOISacDist( sacStruct, aoiCenter, maxDist, AOIsOfInterest ) 



saccadeVec = sacStruct.saccadeVec;
% % startSacPos = sacStruct.startSacPos;
endSacPos = sacStruct.endSacPos;


% % % scale eye tracks(using default value ), calculate fixations
% % [ eyePos ] = scaleEyeTrack( eyePos,  [] ); 
% % [ saccadeVec startSacPos endSacPos ] = codeSaccades( eyePos);


numFixation = size(endSacPos,2);
numSamples = length( saccadeVec );
latency = numSamples;

for i1 = 1:numFixation  
    dist = calc2Dist( endSacPos(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist && sum(minIdx == AOIsOfInterest)
         latency = find(  saccadeVec == i1 );
         latency = latency(end);  %/numSamples; % look at end of saccade
         break;
    end       

end



    

