% Example for easy use


% load up data
dataStructRaw = loadFromTable( 'exampleTable.txt' );

% smooth and interpolate
dataStruct = smoothTracks( dataStructRaw );


% extract variables
varParams.imageSize = [1024; 1280]; % set image size (h,width)
varParams.numFixationInSeq = 5;  % keep up to 5 fixations
aoiPositions = [ 20, 40;  % x1, x2
                 40, 80]; % y1, y2  
aoiRadius = 30;  % 30 pixel radius for AOI cicular region
relevantAOIs = 1;  % AOI (x1,y1) is relevant AOI 
[ featureVect, varParams ] = extractVarsDist( dataStruct.trackCell, aoiPositions, aoiRadius, relevantAOIs, varParams );


% find variables that separate
numWanted = 5;
[ bestVariablesLR ] = sortVariablesLR( featureVect, dataStruct.allLabels, numWanted );
                
[ bestVariablesBayes] = sortVariablesNB( featureVect, dataStruct.allLabels, ...
                dataStruct.sampsPerSubj, numWanted );             

% automatically find labels           
% labels = autoLabel( featureVect ) ;           
            
            
% output best variables
describeVariables( varParams, bestVariablesLR );   

% validate using classifier
[ percCorrectLDA, wLDA ] = runLDALeave1Out( featureVect(bestVariablesLR,:), dataStruct.allLabels, dataStruct.sampsPerSubj );
% [ percCorrectLR, wLR ] = runLRLeave1Out( featureVect(bestVariablesLR,:), dataStruct.allLabels, dataStruct.sampsPerSubj );
% [ percCorrectSVM, wSVM  ] = runSVMLeave1Out( featureVect(bestVariablesLR,:), dataStruct.allLabels, dataStruct.sampsPerSubj );


% output for analysis
exportToTable( dataStruct, featureVect(bestVariablesLR,:), 'outTemp.txt' )


% visualize 
imgFile = 'AOI_Dense_Test.bmp';
eyePos = dataStruct.trackCell{1};
eyePosUnfilt  = dataStructRaw.trackCell{1};
visualizeTrackDist(  eyePos, eyePosUnfilt, imgFile, varParams);

