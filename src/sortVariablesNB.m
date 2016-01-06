% Naive bayes ranking of variables (using CV accuracy criterion)
% 
% syntax: [ bestVariables bestToWorst accuracy ] = sortVariablesNB( featureVect, classLabels, ...
%                 numSamplesPerSubj, topVarsToKeep )
% 
% Inputs:
%   featureVect: all the the data samples in (dim x numSamples)
%   classLabels: all class labels (0 for not learned, 1 for learned, 2 unsure.  
%      The ones labeled class 2 will not be used.
%   numSamplesPerSubj: featureVect assumed to be such that each subject has
%      some number of samples (specified by each entry of numSamplesPerSubj),
%      and they are grouped consecutively. This paramter is needed to do 
%      the leave 1 subject out cross  validation.
%   topVarsToKeep: index of number of best variables to return
% 
% Outputs:
%   bestVariables: indices of top variables to separate the classes
%   bestToWorst: index ordering all the variables (not just the top)
%   accuracy:  associated number correct for those indices
% 

function [ bestVariables, bestToWorst, accuracy ] = sortVariablesNB( featureVect, classLabels, ...
                numSamplesPerSubj, topVarsToKeep )

if nargin < 4 || isempty( topVarsToKeep)
    topVarsToKeep = 10;
end

% leave one subject out cross validation
[ dim, numSamples] = size( featureVect);
expLabels = getLeave1OutLabels( numSamples, numSamplesPerSubj);
numTrials = length(expLabels);
accuracy = zeros( dim,1); %,numTrials);

% center and scale variables to unit variance
featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
featStdev = std( featureVect, 0, 2);
featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);
% featureVect = featureVect./repmat( std( featureVect, 0, 2)+.001, [1,numSamples]);


for i1 = 1:numTrials 
    
    trainLabels = classLabels(:,expLabels(i1).train);
    trainFeatures = featureVect(:,expLabels(i1).train);
    trainFeatures( :, trainLabels==2) = [];
    trainLabels( :, trainLabels==2) = [];
    
    testLabels = classLabels(:,expLabels(i1).test);
    testFeatures = featureVect(:,expLabels(i1).test);
    testFeatures( :, testLabels==2) = [];
    testLabels( :, testLabels==2) = [];
    
    % do the tests on each feature
    for i2 = 1:dim
        if var( trainFeatures(i2,:)) < 1e-5 || ...
            var( trainFeatures(i2,trainLabels==0))< 1e-5 || ...
            var( trainFeatures(i2,trainLabels==1))< 1e-5 ,        
            
                % do nothing
                %accuracy(i2,i1) = 0;
        else
%             var( trainFeatures(i2,:))
%             var( trainFeatures(i2,trainLabels==0))
%             var( trainFeatures(i2,trainLabels==1))
            
            nb = NaiveBayes.fit(trainFeatures(i2,:)', trainLabels', 'Prior', 'uniform');
            estimate = nb.predict(testFeatures(i2,:)');          
            accuracy(i2) = accuracy(i2) + sum( estimate == testLabels'); %/length(testLabels);
        end
    end
%      training is an N-by-D numeric matrix of training data. Rows of training
%      correspond to observations; columns correspond to features. class is a 
%      classing variable for training (see Grouped Data) taking K distinct levels.
%      Each element of class defines which class the corresponding row of training 
%      belongs to. training and class must have the same number of rows.

% 'Prior' – The prior probabilities for the classes, specified as one of the following:
% 
% 'empirical' (default)	fit estimates the prior probabilities from the relative frequencies of the classes in training.
% 'uniform'

end

% % % % sort variables in order best to worst
% % % [ accuracy bestToWorst] = sort( accuracy, 1, 'descend');
% % % %feature selection
% % % bestVariables = bestToWorst(1:topVarsToSearch,:);
% % % bestVariables = bestVariables(:);
% % % uniqVars = unique( sort(bestVariables) );
% % % lengthList = zeros( length(uniqVars),1);
% % % for i1 = 1:length(uniqVars)
% % %    lengthList(i1) = length( find( bestVariables == uniqVars(i1)));    
% % % end
% % % [ val idx] = sort( lengthList , 'descend');


% sort variables in order best to worst
[ accuracy bestToWorst] = sort( accuracy, 1,'descend');

% remove redundancies
unqIdx = findRedundancies( featureVect( bestToWorst,:) );
bestToWorst = bestToWorst(unqIdx);

bestVariables = bestToWorst(1:min(topVarsToKeep, length(bestToWorst) ));
