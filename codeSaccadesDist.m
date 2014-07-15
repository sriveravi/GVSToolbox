% identify saccades
% July 11, 2011
% Notes: This function codes the saccades
% 
% syntax: [sacStruct ]  = codeSaccades( eyeTrack, velThreshold, stopThreshold )
% 
% Inputs: 
%       eyeTrack: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%           missing data. Data should be scaled according to the image dimensions.  
%           See function 'scaleEyeTrack'.
%       velThreshold: min Euclidean pixel distance to travel in one sample unit time to
%          be considered a saccade
%       stopThreshold: max distance to travel in one sample to be considered a stop 
%  
% Outputs:
%       saccadeVector: vector having 0 where no fixations, then 1, 2 ,3,
%           and so on for the fixations in the sequence
%       startSacPos: in format [ x x x ... x; y y y ... y]
%       endSacPos: in format [ x x x ... x; y y y ... y]
%           

function [  sacStruct  ] = codeSaccadesDist( eyeTrack, velThreshold, stopThreshold)

    if nargin < 2 || isempty( velThreshold)
        velThreshold = 20;
    end
    if nargin < 3 || isempty( stopThreshold )
        stopThreshold = 8;
    end

    numSamples =  length( eyeTrack);
    saccadeVec = zeros(numSamples ,1);
    startSacPos = zeros( 2, numSamples );
    endSacPos = zeros( 2, numSamples );
    startPos = 1; 
    peakVelIdx = 1; %make sure it starts, will become -1 if none
    k1 = 1;
    % find all saccades based on a velocity threshold
    while (peakVelIdx > 0) && (startPos < numSamples ) 
            [ sacIdxStart sacIdxEnd peakVelIdx] = findSaccade(  eyeTrack, velThreshold, stopThreshold, startPos );
            if (peakVelIdx > 0)
                startSacPos(:,k1) = [ real( eyeTrack(sacIdxStart)); imag( eyeTrack(sacIdxStart))  ];
                endSacPos(:,k1) = [ real( eyeTrack(sacIdxEnd)); imag( eyeTrack(sacIdxEnd))  ];                    
                saccadeVec(sacIdxStart:sacIdxEnd) = k1;
                startPos = sacIdxEnd+1;
                k1 = k1+1;
            end                       
    end
    
    startSacPos(:,k1:end) = []; %clean up unused parts
    endSacPos(:,k1:end) = [];
    
    
    sacStruct.saccadeVec = saccadeVec;
    sacStruct.startSacPos = startSacPos;
    sacStruct.endSacPos = endSacPos;
      
    
end

%---------------------------------------------------
 %--------------------------------------------------------
 
function [ sacIdxStart, sacIdxEnd, peakVelIdx] = findSaccade(  eyeTrack, velThreshold, stopThreshold, startPos )

% % velThreshold = 20;
% % stopThreshold = 5;
% % eyeTrack = eyePos;
% % startPos = [];

   
    %--------------- initialize -----------------------
    windowSize = 2;
    minTracksToConsider = 2;
    numSamples = length( eyeTrack);
    dist = -1*ones( numSamples,1);
    eyeTrack =  [ real( eyeTrack(:)) imag(eyeTrack(:)) ]'; % in [ x x ... x; y y ... y ]
    maxPos = size( eyeTrack,2) - windowSize+1;

    peakVelIdx = -1;
    sacIdxStart = startPos;
    sacIdxEnd = -1;
    
    % specify search start position
    if nargin < 4 || isempty( startPos )   
        i1 = 0;
    else
        i1 =  startPos-1;
    end

    %--------------------------------------------------------
    %-----------find saccade based on velocity threshold ----------
    saccadeFound = 0;
    while (i1 < maxPos) 
        %increment, until start with not missing if necessary
         i1 =  i1+1;     
        while (i1 < maxPos) && (eyeTrack(1,i1)==-1) 
            i1 =  i1+1; 
        end
        % select window of windowSize samples, expand if 
        % too much missing data or if last sample is missing
        i2 = 0; %for expanding window
        
        
        window = eyeTrack(:, i1:(i1+windowSize-1));        
        missIdx = find( window(1,:) == -1 );
        window( :, missIdx ) = [];
        % old way
%         window( window==-1) = [];
                       
        window = reshape( window, 2,[]);
        
        
        while ( (size( window,2) < minTracksToConsider ) || ...
                    (eyeTrack(1, i1+windowSize-1+i2)==-1)  ) ...
                     && (i1+i2)<maxPos  % do not expand too far
            i2 = i2+1;
            window = eyeTrack(:, i1:(i1+windowSize-1+i2));
            missIdx = find( window(1,:) == -1 );
            window( :, missIdx ) = [];
        % old way             
%             window( window==-1) = [];
        end

        % find start position, and end position of saccade based on a
        % threshold velocity for starting slow, middle fast, end slow
        window = reshape( window, 2,[]);  
        if size( window,2) >= minTracksToConsider %handle missing data                      
            % distance traveled per time unit
            dist(i1) = norm( [window(:,end) - window(:,1)], 'fro')/(windowSize+i2-1); 
            if (dist(i1) < stopThreshold) && ( saccadeFound < 1) %start condition
                sacIdxStart = i1;
            end
            if (dist(i1) > velThreshold) && (sacIdxStart >0 ) %threshold condition
                saccadeFound = i1;
            end
            if (dist(i1) < stopThreshold) && ( saccadeFound > 1) %end condition                     
                if sacIdxEnd < 0 % set initial slowdown
                    sacIdxEnd = i1;                
                end
                if dist(i1) > dist( sacIdxEnd )  % find end point (when start speeding up again)          
                    [ peakVel peakVelIdx   ] = max( dist(sacIdxStart:sacIdxEnd));
                    peakVelIdx = peakVelIdx+ sacIdxStart-1;                    
                    break;
                else % gaze still slowing down
                    sacIdxEnd = i1;
                end
            end            
        end            
    end % end while

    % don't count saccade if no end point
    if ( saccadeFound > 1) && sacIdxEnd ==-1        
        peakVelIdx =-1;
        sacIdxStart = -1;
    end

end
  