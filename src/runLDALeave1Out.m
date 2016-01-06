% calculate leave 1 subject out accuracy for Bayes classifier with equal covariance
% 
% syntax: [ percCorrect w ] = runLDALeave1Out( featureVect, classLabels, numSamplesPerSubj )
% 
% Inputs:
%   featureVect: (dim x numSamples) matrix of data
%   classLabels: class labels, valued [0,1,2] for visualization, leave empty to
%       not visualize. Originally, class 1 for learn, 0 for didn't learn,
%       2 for remove because unclear
%   numSamplesPerSubj: as name implies, for splitting up the data into
%      leave 1 subject out cross validation
%   expLabels: optional input usually returned by 'getLeave1OutLabels'
%      function which specifies how to partition the data for leave 1
%      subject out cross validation
% 
% Outputs:
%   percCorrect: percentage correctly classified by leave 1 subj out CV
%   w: w vector returned by all the well labeled data
%   predictedVsTrue: cell containing the [predeicted ; true] labels of the
%       data for each fold of the cross validation
% 
% Note, class 1 for learn, 0 for didn't learn, 2 for remove because unclear


function  [ percCorrect w predictedVsTrue] = runLDALeave1Out( featureVect, classLabels, ...
                                    numSamplesPerSubj, expLabels )

numSamples = size( featureVect,2);

% center and scale variables to unit variance
featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
featStdev = std( featureVect, 0, 2);
featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);
% featureVect = featureVect./repmat( std( featureVect, 0, 2)+.001, [1,numSamples]);


if nargin < 4 || isempty(expLabels)
    expLabels = getLeave1OutLabels( numSamples, numSamplesPerSubj);
%     expLabels = balanceClasses( expLabels, classLabels );  % even out number samples in each class
end
numTrials = length(expLabels);

classIndices = cell(2,1);
numCorrect = 0;
totalNumTest = 0;


predictedVsTrue = cell( numTrials,1 );


% leave one subject out cross validation
for i1 = 1:numTrials  
    % training
    
    trainLabels = classLabels(:,expLabels(i1).train);
    trainFeatures = featureVect(:,expLabels(i1).train);
    trainFeatures( :, trainLabels==2) = [];
    trainLabels( :, trainLabels==2) = [];
    
    testLabels = classLabels(:,expLabels(i1).test);
    testFeatures = featureVect(:,expLabels(i1).test);
    testFeatures( :, testLabels==2) = [];
    testLabels( :, testLabels==2) = [];
    
    if ~isempty( testLabels)     
        classIndices{1} = find( trainLabels == 0); % non learning
        classIndices{2} = find( trainLabels == 1); % learning
                          
        meanVec = [ mean(trainFeatures(:,classIndices{1}),2), ...
                    mean(trainFeatures(:,classIndices{2}),2) ]; 
        Xtemp1 = [ trainFeatures(:,classIndices{1}) -  repmat( meanVec(:,1), [1,length(classIndices{1})])];                
        Xtemp2 = [ trainFeatures(:,classIndices{2}) -  repmat( meanVec(:,2), [1,length(classIndices{2})]) ];
        Sw = (Xtemp1*Xtemp1' + Xtemp2*Xtemp2')./length(trainLabels);
        
        %Sw = cov( trainFeatures');
        w = normc( pinv(Sw)*(meanVec(:,1) - meanVec(:,2)) );

        % testing
        projMeans = w'*meanVec;
        projectedData = w'*testFeatures;
        diffMatrix = sqrt((repmat(projMeans', [1,length(projectedData)]) ...
                        - repmat( projectedData,[length(projMeans),1]) ).^2);
        [c Idx ] = min( diffMatrix, [], 1);
        predictedLabels = Idx-1;  % class labels are 0,1 , in that order (of means) 

        %     predictedLabels
        %     sum(testLabels == predictedLabels );    
        tempNumCorrect = sum(testLabels == predictedLabels );
        numCorrect = numCorrect+ tempNumCorrect;
        numTest = length(predictedLabels);
        totalNumTest = totalNumTest+numTest;  
        fprintf( 'Accuracy = %.2f, (%d/%d), %d Guessed 1; Train # class 1: %d, class 0: %d. \n', ...
            tempNumCorrect/numTest, tempNumCorrect,numTest, length(find(predictedLabels==1)), ...
            length(find(trainLabels==1)), length(find(trainLabels==0)));
        
        predictedVsTrue{i1} = [ predictedLabels; testLabels];
        
    end
    
end
percCorrect = numCorrect/totalNumTest; %length(classLabels~=2); 
%----------------------------

% find optimal w for all the data
featureVect( :, classLabels==2) = [];
classLabels( :, classLabels==2) = [];
classIndices{1} = find( classLabels == 0); % non learning
classIndices{2} = find( classLabels == 1); % learning

meanVec = [ mean(featureVect(:,classIndices{1}),2), ...
                    mean(featureVect(:,classIndices{2}),2) ];                 
Xtemp1 = [ featureVect(:,classIndices{1}) -  repmat( meanVec(:,1), [1,length(classIndices{1})])];                
Xtemp2 = [ featureVect(:,classIndices{2}) -  repmat( meanVec(:,2), [1,length(classIndices{2})]) ];
Sw = (Xtemp1*Xtemp1' + Xtemp2*Xtemp2')./length(classLabels);
        
w = pinv(Sw)*(meanVec(:,1) - meanVec(:,2));
w = -w;



