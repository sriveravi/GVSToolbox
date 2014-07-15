% visualize the gaze data
%
% Syntax:  visualizeTrackSingle(  leftEyePos, leftOri, imgFile, varParams, stimSize)
% 
% Inputs: 
%        leftEyePos: vector of complex eye tracks in [0,1] range 
%        leftOri: optional unfiltered tracks( if leftEyePos filtered), 
%           leave [] to not plot 
%        imgFile: a string specifying the image stimulus file, like 'image.bmp',
%        varParams: struct which specifies the parameters for detecting
%           fixations (using IDT algorithm) and saccades. See lines 20-24
%           for the possible parameters

function visualizeTrackDist(  leftEyePos, leftOri, imgFile, varParams, stimSize )


% default fixation paramters
if ~isfield( 'varParams', 'fixMinNumSamples'); varParams.fixMinNumSamples = 6;  end  % in number neighboring samples, 6 scamples correspond to 100ms at 60Hz   
if ~isfield( 'varParams', 'fixMaxCircleRadius'); varParams.fixMaxCircleRadius = 15;  end % in pixels, half diameter
% identify saccades as exceeding a certain velocity, then slow down
if ~isfield( 'varParams', 'velThreshold'); varParams.velThreshold = 20; end
if ~isfield( 'varParams', 'stopThreshold'); varParams.stopThreshold = 8; end

fixMinNumSamples = varParams.fixMinNumSamples;
fixMaxCircleRadius = varParams.fixMaxCircleRadius;
velThreshold = varParams.velThreshold;
stopThreshold = varParams.stopThreshold;


% load stimulus image 
if isempty(imgFile)
    A = zeros( stimSize(1), stimSize(2), 3);
else
    A = imread( imgFile ); 
end

% setup figure
% close all
hFig=figure(2);
set( hFig, 'renderer', 'opengl')
axis off;
set(hFig,'renderermode','auto');


% for i2 = 1:length(gazeStruct) 

    % scale acoording to image size (if it is within the [0 1] range)    
    if max(real(leftEyePos)) <= 1
        leftEyePos = scaleEyeTrack( leftEyePos, size(A(:,:,1)) );
        if ~isempty( leftOri )
            leftOri = scaleEyeTrack(leftOri, size(A(:,:,1)) );
        end
    end
    numSamples = length( leftEyePos );
    
    % extract fixation information
    fprintf( 'Finding fixations and saccades... ');
    fixStruct = codeFixationsDist( leftEyePos, fixMinNumSamples, fixMaxCircleRadius );
    leftFixation = fixStruct.fixationVector;
    sacStruct = codeSaccadesDist( leftEyePos, velThreshold, stopThreshold);       
    leftSaccade =  sacStruct.saccadeVec;    
    fprintf( 'done!\n');

    % now plot the eye tracks
    secCount = 0;
    for i1 = 2:1:numSamples  % for (near) real time, step by 2
        % show appropriate image     
        imshow( A );  % imagesc faster than imshow
        %show fixations and saccades 
        if  leftFixation(i1)~=0
            text(100,60, ['F' int2str(leftFixation(i1))], 'fontsize', 30, 'color', 'b' ); %left fixation            
        end        
        if  leftSaccade(i1)~=0
            text(100,100, ['S' int2str(leftSaccade(i1))], 'fontsize', 30, 'color', 'b' ); %left Saccade
        end
        % plot the eye tracks
        hold on; 
        plot( leftEyePos(i1), 'b*' );        
        if ~isempty( leftOri )
            plot( leftOri(i1), 'w.' );
        end
        pause(.02);
        % update time, assuming sampling at 60Hz
        if mod( i1, 60 ) == 0
            % endTime = toc;
            % fprintf( '%d seconds for 60 frames.\n', endTime-startTime );        
            % startTime = endTime;                
            secCount = secCount+1;
        end

        hold off;
    end

% end


