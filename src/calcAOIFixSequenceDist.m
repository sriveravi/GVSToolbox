% calculate matrix representing the sequence of AOIs fixated
% 
% Syntax: [ AOISequence AOIDuration] =calcAOIFixSequence( eyePos, aoiCenter, maxDist, maxFixations) 
% 
% Inputs:
%  fixStruct: returned from codeFixationsDist
%  aoiCenter: coordinates of AOI in image scale, returned by 'returnAOICenters.m'
%  maxDist: maximum distance to a nearest AOI, anything further
%   considered not part of any AOI, returned by 'returnAOICenters.m'
%  maxFixations: number of fixations in the sequence to keep
% 
% Outputs:
%  AOISequence: matrix (numAOI x numFix) with an indicator (1) for
%       in each column corresponding to the AOI of interest.  If no
%       AOI, it will be an all 0;
%  AOIDuration: matrix (1 x numFix) for duration in number samples at that
%       AOI, will be 0 if no AOI

function [ AOISequence AOIDuration  ] =calcAOIFixSequenceDist( fixStruct, aoiCenter, maxDist, maxFixations ) 


fixPosVector = fixStruct.fixPosVector;
fixDurVector = fixStruct.fixDurVector;

% % % initialize some paramters
% % fixationWinSize = 6;
% % fixationThreshold = 15;
if nargin < 4 || isempty( maxFixations )
    maxFixations = 4;
end
% % 
% % % scale eye tracks(using default value ), calculate fixations
% % [ eyePos imRange] = scaleEyeTrack( eyePos,  [] ); 
% % [ fixationVector P ]  = codeFixations( eyePos, fixationWinSize, fixationThreshold );

% initialize some variables
numAOI = size(aoiCenter,2);
numFixation = size( fixPosVector,2);
AOIOrderList = zeros(numFixation,1); 
AOIDurationList =  zeros(numFixation,1);
effectivNumFixation = 0;

% find AOI fixation sequence
for i1 = 1:numFixation  
    dist = calc2Dist( fixPosVector(:,i1), aoiCenter); % 2-norm 
    [minDist minIdx] = min( dist);    
    if minDist < maxDist         
        effectivNumFixation = effectivNumFixation+1;        
        AOIOrderList(effectivNumFixation) = minIdx;
        AOIDurationList(effectivNumFixation ) = fixDurVector(i1); %length(find(fixationVector==i1));
    end
end

% code as a matrix of indicator variables
if effectivNumFixation >0  
    AOISequence = zeros( numAOI, maxFixations); 
    AOIDuration = zeros( 1, maxFixations);
    for i1 = 1:min(effectivNumFixation, maxFixations) 
        AOISequence(AOIOrderList(i1),i1) = 1; % indicator for AOI (1)
        AOIDuration(i1) = AOIDurationList(i1);
    end
    
else % all 0 if no relevant AOI
    AOISequence = zeros( numAOI,maxFixations);
    AOIDuration = zeros( 1, maxFixations);
end




