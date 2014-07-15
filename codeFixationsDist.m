% identify fixations
% June 22, 2011
% Notes: This function codes the eye track sequence according to the fixations
%   It checks to make sure that the fixation is not immediately at start of
%   sequence (from fixation slide) and eliminates this fixation if necessary
%   We identify fixations using the IDT algorithm
% 
% syntax: [ fixStruct ]  = codeFixations( eyeTrack, windowSize, viewThreshold )
% 
% Inputs: 
%       eyeTrack: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%           missing data. Data should be scaled according to the image dimensions.  
%           See function 'scaleEyeTrack'.
%       windowSize: integer of consecutive frames which should be within a
%           threshold of distance from one another (to be considered a
%           fixation) , ( 6 is good value for 60 Hz)
%       viewThreshold: euclidean distance within which eye positions are
%           considered part of same fixation, 15 is a good number for 30 px
%           diameter
%  
% Outputs:
%       fixStruct, having 
%       fixStruct.fixDurVector: vector of (fx1),  for duration of fications
%       fixStruct.fixPosVector: in format [ x x x ... x; 
%                                                          y y y ... y]
%       fixStruct.fixationVector: (N by1) vector having 0 where no fixations, then 1, 2 ,3,
%           and so on for the fixations in the sequence


function [ fixStruct ] = codeFixationsDist( eyeTrack, windowSize, viewThreshold )

    if nargin < 2
        windowSize = 6;
    end
    if nargin < 3
        viewThreshold = 15;
    end

    numSamples =  length( eyeTrack);
    fixationVector = zeros(numSamples ,1);  
    fixDurVector = zeros(numSamples ,1);  
    fixPosVector = zeros( 2, numSamples );
    startPos = 1; 

    fixIndex = 1;  fixLength = 0; k1 = 1;
    while  ( fixIndex~=-1 ) && (startPos < numSamples ) 
        %     [k1 fixIndex fixLength]    
        [fixIndex fixPosition fixLength] = findFixation(  eyeTrack, windowSize, viewThreshold, startPos );
        startPos = fixIndex + fixLength;
        if  fixIndex~=-1 
            fixationVector( fixIndex:(fixIndex+fixLength-1)) = k1;
            fixPosVector(:,k1 ) = fixPosition(:);
            fixDurVector(k1,1) = fixLength;
            k1 = k1+1;
        end
        
    end
    fixPosVector(:,k1:end) = []; %clean up unused parts
    fixDurVector( k1+1:end) = [];
    
    
    % eliminate first fixation if it coincides with the 
    % fixation slide ( start of sequence)
    if fixationVector(1) == 1
        fixationVector( fixationVector==1) = 0;
        fixationVector( fixationVector ~= 0 ) = fixationVector( fixationVector ~= 0 )-1;
        fixPosVector( :,1) = [];
        fixDurVector(1) = [];
    end

    fixStruct.fixPosVector = fixPosVector;
    fixStruct.fixDurVector = fixDurVector;
    fixStruct.fixationVector = fixationVector;
    
end
%---------------------------------------------------

% Outputs:
%      fixIndex: integer index for beginning of fixation. -1 if none found
%      fixPosition: vector of the fixation position (mean of the window) -1 if none found
%      fixLength: : integer specifying total length of fixation, -1 if none found

function [fixIndex, fixPosition, fixLength] = findFixation(  eyeTrack, windowSize, viewThreshold, startPos )

    %--------------------------------------------------------
    %--------------- initialize -----------------------

    minTracksToConsider = floor( 2/3 * windowSize ); % integer, specifying minimum samples
                                                                                 %   tracked when calculating fixation                                                                        
    eyeTrack =  [ real( eyeTrack(:)) imag(eyeTrack(:)) ]'; % in [ x x ... x; y y ... y ]
    maxPos = size( eyeTrack,2) - windowSize+1;
    fixPosition = -1; fixLength = -1;
    fixIndex = -1; % will stay -1 if none found

    % specify search start position
    if nargin < 4 || isempty( startPos )   
        i1 = 0;
    else
        i1 =  startPos-1;
    end

    %--------------------------------------------------------
    %-----------find fixation position --------------------------

    while (i1 < maxPos) && (fixIndex==-1)

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
%         window = reshape( window, 2,[]);
        while ( (size( window,2) < minTracksToConsider ) || ...
                    (eyeTrack(1, i1+windowSize-1+i2)==-1)  ) ...
                     && (i1+i2)<maxPos  % do not expand too far
            i2 = i2+1;
            window = eyeTrack(:, i1:(i1+windowSize-1+i2));
            missIdx = find( window(1,:) == -1 );
            window( :, missIdx ) = [];
            % old way
    %         window( window==-1) = [];
    %         window = reshape( window, 2,[]);
        end

        % determine if fixation based on viewThreshold

        %         window = reshape( window, 2,[]);
        if size( window,2) >= minTracksToConsider %handle missing data
            
            %         dist = ( repmat(mean(window,2),1,size(window,2)) - window);
            %         dist = sqrt(sum(dist.^2,1));        
            dist = calc2Dist( mean(window,2), window); %euclidean distance from mean to all
            if max( dist ) < viewThreshold
                fixIndex = i1; %store fixation position
                fixPosition =  mean(window,2);
            end        
        end    

    end

    %---------------------------------------------------------
    %-----------find fixation duration ( if fixation found)------------

    if  fixIndex ~= -1

        % initialize for keeping track/convenience
        eyeTrack(:,1:fixIndex-1) = [];
        missingIndices = 1:size(eyeTrack,2);
        knownIndices = missingIndices( eyeTrack(1,:)~=-1);
        missingIndices( eyeTrack(1,:)~=-1) = [];
        eyeTrack( :, missingIndices) = [];  

         % find furthest index within threshold distance
         dist = calc2Dist( fixPosition, eyeTrack);
         i1 =1;
         while  (i1<=length(dist)) && (dist(i1) < viewThreshold) 
             i1 = i1+1; 
         end;      
         fixLength = knownIndices(i1-1);

    end

end
