
% calculate leave 1 subject out accuracy for L1 penalized logistic regression
% 
% syntax: [ percCorrect w ] = runLRLeave1Out( featureVect, classLabels, numSamplesPerSubj, lambdaScalar, expLabels )
% 
% Inputs:
%   featureVect: (dim x numSamples) matrix of data
%   classLabels: class labels, valued [0,1,2] for visualization, leave empty to
%       not visualize. Originally, class 1 for learn, 0 for didn't learn,
%       2 for remove because unclear
%   numSamplesPerSubj: as name implies, for splitting up the data into
%      leave 1 subject out cross validation
%   lambdaScalar: optional input specifying regularization parameter for
%       the  L1 penalized Logistic Regression
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

function [ percCorrect w predictedVsTrue] = runLRLeave1Out( featureVect, classLabels, numSamplesPerSubj, lambdaScalar, expLabels )

if nargin < 4 || isempty( lambdaScalar)
    lambdaScalar = 1;
end

% leave one subject out cross validation
[ dim numSamples] = size( featureVect);

% center and scale variables to unit variance
featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
featStdev = std( featureVect, 0, 2);
featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);
% featureVect = featureVect./repmat( std( featureVect, 0, 2)+.001, [1,numSamples]);

featureVect = [ones(numSamples,1) featureVect']'; % Add Bias element to features (at top)
classLabels( classLabels == 0) = -1; % Convert y to {-1,1} representation

if nargin < 5 || isempty(expLabels)
    expLabels = getLeave1OutLabels( numSamples, numSamplesPerSubj);
%     expLabels = balanceClasses( expLabels, classLabels );  % even out number samples in each class
end
numTrials = length(expLabels);

% init weights and lambda
w_init = zeros(dim+1,1);
lambda = lambdaScalar*ones(dim+1,1);  %15 %[ 1./(std( featureVect, 0, 2)+.01)]; %
lambda(1) = 0; % Do not penalize bias variable
options = struct('verbose',0);
totalNumTest = 0;
numCorrect = 0;


predictedVsTrue = cell( numTrials,1 );

for i1 = 1:numTrials 
    
    trainLabels = classLabels(:,expLabels(i1).train);
    trainFeatures = featureVect(:,expLabels(i1).train);
    trainFeatures( :, trainLabels==2) = [];
    trainLabels( :, trainLabels==2) = [];
    
    testLabels = classLabels(:,expLabels(i1).test);
    testFeatures = featureVect(:,expLabels(i1).test);
    testFeatures( :, testLabels==2) = [];
    testLabels( :, testLabels==2) = [];

    if ~isempty( testLabels) 
        % training L1-Regularized Logistic Regression
        % define objective variables    
        funObj = @(w)LogisticLoss(w,trainFeatures',trainLabels');
        w = L1GeneralProjection(funObj,w_init,lambda, options );

        % testing, 
        predictedLabels = sign(testFeatures'*w);
        tempNumCorrect = sum(testLabels' == predictedLabels);
        numCorrect = numCorrect + tempNumCorrect;
        numTest = length(testLabels);
        totalNumTest = totalNumTest+numTest;
        % Output things
        fprintf( 'Accuracy = %.2f, (%d/%d), %d Guessed 1; Train # class 1: %d, class 0: %d. \n', ...
            tempNumCorrect/numTest, tempNumCorrect,numTest, length(find(predictedLabels==1)), ...
            length(find(trainLabels==1)), length(find(trainLabels==-1)));
        
        predictedLabels( predictedLabels == -1) = 0;
        testLabels( testLabels == -1) = 0;
        predictedVsTrue{i1} = [ predictedLabels'; testLabels];
                
    end
end
percCorrect = numCorrect/totalNumTest; %length(classLabels~=2); 

% normal vector of optimal hyperplane (ALL DATA)
featureVect( :, classLabels==2) = [];
classLabels( :, classLabels==2) = [];

funObj = @(w)LogisticLoss(w,featureVect',classLabels');
w = L1GeneralProjection(funObj,w_init,lambda, options);
w(1) =[];






