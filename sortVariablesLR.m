% L1 penalized logistic regression ranking of variables
% 
% syntax: [ bestVariables bestToWorst  ] = sortVariablesLR( featureVect, classLabels, ...
%                 topVarsToKeep, topVarsToSearch )
% 
% Inputs:
%   featureVect: all the the data samples in (dim x numSamples)
%   classLabels: all class labels (0 for not learned, 1 for learned, 2 unsure.  
%      The ones labeled class 2 will not be used.
%   topVarsToKeep: index of number of best variables to return
%   topVarsToSearch: To find topVarsToKeep, we look at the most frequently
%       top ranked variables within the (first:topVarsToSearch ) variables
%       across all folds of leave subject out cross validation
% 
% Outputs:
%   bestVariables: indices of best variables to separate the classes
%   bestToWorst: index ordering all the variables for all CV folds
%

function [ bestVariables bestToWorst  ] = sortVariablesLR( featureVect, classLabels, ...
                topVarsToKeep, topVarsToSearch )

if nargin < 3 || isempty( topVarsToKeep)
    topVarsToKeep = 10;
end
if nargin < 4 || isempty( topVarsToSearch )
    topVarsToSearch = topVarsToKeep;
end


% leave one subject out cross validation
[ dim numSamples] = size( featureVect);
% expLabels = getLeave1OutLabels( numSamples, numSamplesPerSubj);
numTrials = 1; % length(expLabels);
bestToWorst = zeros( topVarsToSearch, numTrials);

% center and scale variables to unit variance
featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
featStdev = std( featureVect, 0, 2);
featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);
% featureVect = featureVect./repmat( std( featureVect, 0, 2)+.001, [1,numSamples]);

% init some thing for LR
featureVect = [ones(numSamples,1) featureVect']'; % Add Bias element to features (at top)
classLabels( classLabels == 0) = -1; % Convert y to {-1,1} representation
baseLambda = ones(dim+1,1);  % [ 1./(std( featureVect, 0, 2)+.001)]; % 15
options = struct('verbose',0);


for i1 = 1; %:numTrials 
    
    % init weight and lambda scalar every trial
    w = zeros( dim+1,1); %  make sure it goes into while loop
    lambdaScalar = 150;
    
    
    trainLabels = classLabels; %(:,expLabels(i1).train);
    trainFeatures = featureVect; %(:,expLabels(i1).train);
    trainFeatures( :, trainLabels==2) = [];
    trainLabels( :, trainLabels==2) = [];
    funObj = @(w)LogisticLoss(w,trainFeatures',trainLabels'); % LR objective
    
%     testLabels = classLabels(:,expLabels(i1).test);
%     testFeatures = featureVect(:,expLabels(i1).test);
%     testFeatures( :, testLabels==2) = [];
%     testLabels( :, testLabels==2) = [];
    
    % do the tests on each feature
    k1 = 0;
    while nnz( w) < topVarsToSearch && k1 < 500
        k1 = k1+1;

        lambda = lambdaScalar*baseLambda;
        lambda(1) = 0; % Do not penalize bias variable
        w = L1GeneralProjection(funObj,w,lambda, options );
        lambdaScalar = lambdaScalar/1.1;
        
        % % testing 
        % predictedLabels = sign(testFeatures'*w);
        % tempNumCorrect = sum(testLabels' == predictedLabels);        
    end
    
    % sort by most important, and put in the matrix
    w(1) = [];
    [ temp bestToWorst] = sort( abs(w(:)), 'descend');  
%     bestToWorst( :,i1) = wIdx(1:topVarsToSearch);
    
end

% %feature selection
% bestVariables = bestToWorst(:);
% uniqVars = unique( sort(bestVariables) );
% lengthList = zeros( length(uniqVars),1);
% for i1 = 1:length(uniqVars)
%    lengthList(i1) = length( find( bestVariables == uniqVars(i1)));    
% end
% [ val idx] = sort( lengthList , 'descend');


% remove redundancies
featureVect(1,:) = [];  %to remove that unit offset

unqIdx = findRedundancies( featureVect(bestToWorst,:) );
bestToWorst = bestToWorst(unqIdx);


bestVariables = bestToWorst(1:min(topVarsToKeep, length(bestToWorst) ));



