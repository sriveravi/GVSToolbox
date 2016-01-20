% calculate leave 1 subject out accuracy for linear SVM
% 
% syntax: [ percCorrect w ] = runSVMLeave1Out( featureVect, classLabels, numSamplesPerSubj, expLabels)
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

function [ percCorrect w predictedVsTrue ] = runSVMLeave1Out( featureVect, classLabels, ...
                                numSamplesPerSubj, expLabels )

% leave one subject out cross validation
[ dim numSamples] = size( featureVect);

% center and scale variables to unit variance
featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
featStdev = std( featureVect, 0, 2);
featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);

if nargin < 4 || isempty(expLabels)
    expLabels = getLeave1OutLabels( numSamples, numSamplesPerSubj);
end

numTrials = length(expLabels);
numCorrect = 0;
totalNumTest=0;
options = ['-t 0 -h 0 -e .01' ];  %-t 0 for linear kernel, h 0 for shrinkage huristic

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
        model = svmtrain(trainLabels', trainFeatures', options );
        [predicted, accuracy, probEst] = svmpredict(testLabels',testFeatures', model);
        numCorrect = numCorrect + accuracy(1)*.01*length(testLabels);            
        totalNumTest = totalNumTest+length(testLabels);  
        
        predictedVsTrue{i1} = [ predicted'; testLabels];
        
    end

end
percCorrect = numCorrect/totalNumTest; %length(classLabels~=2); 

% normal vector of optimal hyperplane (ALL DATA)
featureVect( :, classLabels==2) = [];
classLabels( :, classLabels==2) = [];
model = svmtrain(classLabels', featureVect', options );
w = sum( repmat( model.sv_coef', [dim,1]).*full(model.SVs'),2);

