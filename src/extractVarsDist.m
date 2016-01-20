% extract all variables from a cell of eye tracks
% 
% Syntax: [ featureVect  varParams ] = extractVarsDist( trackCell, aoiPositions, maxDist, relevantAOIs, varParams )
% 
% Inputs: 
%   trackCell: (1 by numSamples) cell with all the mean test tracks
%       extracted.  trackCell{1} will have an (numSample by 1) complex
%       vector of eye coordinates.  It will upscale them to varParams.imageSize 
%       if they are still within the [ 0+0i, 1+1i] range (line 84 )
% 
%   aoiPositions: AOI positions in image
%           with respect original image size,  in format [ x x ... x; 
%                                                          y y ... y]
%   maxDist: max Euclidean distance from each AOI center (in pixels)
%       until it is considered not within the AOI
% 
%   relevantAOIs = [4;11]; % index of the AOI positions which are the 
%       relevant ones for a particular category  
% 
%   varParams: struct with the paramters for fixation, saccades, image size,
%         and histogram bins, etc. scroll down (line 32-44) to see struct fields
%   
% 
% Outputs:
%   featureVect: (d by numSamples) matrix with all the data
%   varParams: struct with variable information in addition to paramters
% 

function [ featureVect,  varParams ] = extractVarsDist( trackCell, aoiPositions, maxDist, relevantAOIs, varParams )
                                   
 
%initialize default parameters for variable extraction
if ~isfield( 'varParams', 'imageSize'); varParams.imageSize = [1024; 1280]; end % [Height; Width] of display
    % We identify fixations using the IDT algorithm
if ~isfield( 'varParams', 'fixMinNumSamples'); varParams.fixMinNumSamples = 6;  end % in number neighboring samples
if ~isfield( 'varParams', 'fixMaxCircleRadius'); varParams.fixMaxCircleRadius = 15;  end % in pixels, half diameter
    % identify saccades as exceeding a certain velocity, then slow down
if ~isfield( 'varParams', 'velThreshold'); varParams.velThreshold = 20; end
if ~isfield( 'varParams', 'stopThreshold'); varParams.stopThreshold = 8; end
    
if ~isfield( 'varParams', 'startFixation'); varParams.startFixation = 1; end
if ~isfield( 'varParams', 'numFixationInSeq'); varParams. numFixationInSeq = 7;  end
if ~isfield( 'varParams', 'startSaccade'); varParams.startSaccade = 1; end
if ~isfield( 'varParams', 'numSaccadesInSeq'); varParams.numSaccadesInSeq = 7; end
% if ~isfield( 'varParams', 'numHistBins'); varParams.numHistBins = 15; end



% setup the variables for later use    
imageSize = varParams.imageSize;
fixMinNumSamples = varParams.fixMinNumSamples;
fixMaxCircleRadius = varParams.fixMaxCircleRadius;
velThreshold = varParams.velThreshold;
stopThreshold = varParams.stopThreshold;
startFixation = varParams.startFixation; 
numFixationInSeq = varParams.numFixationInSeq;  
startSaccade = varParams.startSaccade; 
numSaccadesInSeq = varParams.numSaccadesInSeq;
% numHistBins = varParams.numHistBins;   


%----------------------------------------------
% initialize basic things
if ~iscell( trackCell );
    temp = trackCell; clear trackCell
    trackCell{1} = temp; clear temp
end
numSamples = length(trackCell );
%histDim = numHistBins*length(relevantAOIs);
numAOI = size( aoiPositions,2);   


varParams.dimPerFeat = [ numAOI; numAOI*numFixationInSeq; numFixationInSeq; 1; ...
                         1; 1; 1; ... %histDim; 1; 1; 1; ...
                         numAOI*numSaccadesInSeq; numAOI; 1;
                         2*numFixationInSeq ; 2*numSaccadesInSeq ];
varParams.dimNames = { 'AOIFixDensity'; 'AOIFixationSeq'; 'AOIFixationDuration'; 'relevantAOIFixDensVersusAll'; ...
                        'totalDistTraveled'; 'numUniqueAOIsVisitedFixation'; 'latencyFirstRelAOIFixation'; ... %'AOIFixationDistHistogram'; 'totalDistTraveled'; 'numUniqueAOIsVisitedFixation'; 'latencyFirstRelAOIFixation'; ...
                        'AOISaccadeSeq'; 'AOISaccadeToDensity'; 'latencyFirstRelAOISaccade'; ...
                        'relNonRelFixSeq'; 'relNonRelSacSeq'};
featureVect = zeros( sum(varParams.dimPerFeat ), numSamples);


%---------------------------------------------------
% extract all the variables
 for k1 =1:numSamples
    if max(real(trackCell{k1})) <= 1
        eyePos = trackCell{k1}; % scale eye track if it is within the [0 1] range
    end
    [ eyePos ] = scaleEyeTrack( eyePos,  imageSize ); 
    
    [ fixStruct ] = codeFixationsDist( eyePos, fixMinNumSamples, fixMaxCircleRadius );
    [ sacStruct ] = codeSaccadesDist( eyePos, velThreshold, stopThreshold);
        
    
    % ------------------- extract all variables --------------------
    % calculate AOI fixation density    
     [ AOIDensity numRealFix]  = calcAOIFixDensityDist( fixStruct, aoiPositions, maxDist );    
    
    % calc relevant AOI fixation versus All
    relAOIVersusAll = [ sum(AOIDensity(relevantAOIs))]; %; sum(AOIDensity(nonRelevantAOIs))];
   
    % caculate AOI fixation sequence and duration  
    [ AOISeq AOIDur  ] =calcAOIFixSequenceDist( fixStruct, aoiPositions, maxDist, numFixationInSeq+startFixation-1 );            
    AOISeq = AOISeq(:, startFixation:end);         
    AOIDur = AOIDur(startFixation:end);
    
% %     % histogram distance to relevant AOI
% %     histMatrix =calcAOIFixDistHistDist( fixStruct,  aoiPositions, numHistBins, relevantAOIs, imageSize ); 
    
    % calculate distance traveled
    distTraveled =calcDistTraveled( eyePos );
    
    % calculate number unique AOI's visited
    numUniqAOIs = length(find( AOIDensity>0));
    
    % calculate latency to first relevant AOI fixation
    latencyFirstRelAOI =calcLatencyRelAOIFixDist( fixStruct, aoiPositions, maxDist, relevantAOIs);
        
    % calc relative number saccades to an AOI
    [AOIDensitySac ] =calcAOISacDensityDist( sacStruct, aoiPositions, maxDist );
    
    % calculate saccade sequence
    [ AOISacSequence ] = calcAOISacSequenceDist( sacStruct, aoiPositions,  maxDist, numSaccadesInSeq+startSaccade-1 );
    AOISacSequence = AOISacSequence(:,startSaccade:end);        
 
    % calcualate latency to first saccade to relevant region
    latencyFirstRelAOISac = calcLatencyRelAOISacDist( sacStruct, aoiPositions, maxDist, relevantAOIs );
    
    % calculate sequence as relevant/irrelevant
    relIrelFixSeq =calcIrrRelSeq( AOISeq, relevantAOIs );
    relIrelSacSeq =calcIrrRelSeq( AOISacSequence, relevantAOIs );
        
    %---------------------------------------------------------------
    % put in output matrix
    featureVect(:,k1) = [ AOIDensity; AOISeq(:); AOIDur(:); relAOIVersusAll; ...
                        distTraveled; numUniqAOIs; latencyFirstRelAOI; ... %histMatrix(:); distTraveled; numUniqAOIs; latencyFirstRelAOI; ...
                        AOISacSequence(:); AOIDensitySac; latencyFirstRelAOISac; ...
                        relIrelFixSeq(:); relIrelSacSeq(:) ];
                    
end
