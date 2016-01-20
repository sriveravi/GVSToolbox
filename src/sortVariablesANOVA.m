% anova ranking of variables
% 
% syntax: [bestVariables bestToWorst p ] = sortVariablesANOVA( featureVect, ...
%                         classLabels, topVarsToKeep )
% 
% Inputs:
%   featureVect: all the the data samples in (dim x numSamples)
%   classLabels: all class labels (0 for not learned, 1 for learned, 2 unsure.  
%      The ones labeled class 2 will not be used.
%   topVarsToKeep: index of number of best variables to return
% 
% Outputs:
%   bestVariables: indices of best variables to separate the classes
%   bestToWorst: index ordering all the variables for all CV folds
%   p: associated p values for those indices
% 


function [bestVariables bestToWorst p ] = sortVariablesANOVA( featureVect, ...
                        classLabels, topVarsToKeep )
                  

if nargin < 4 || isempty( topVarsToKeep)
    topVarsToKeep = 10;
end

% leave one subject out cross validation
[ dim numSamples] = size( featureVect);
p = zeros( dim,1);
h = zeros(dim,1);

featureVect(:,classLabels ==2) = [];
classLabels( classLabels ==2) = []; 

% do the tests on each feature
for i2 = 1:dim
    [h(i2,1) p(i2,1) ] = ttest2( featureVect( i2, classLabels==0)', ...
                     featureVect( i2, classLabels==1)',...
                      .05, 'both', 'unequal');        
end    
% [h p]  = ttest2(x,y, .05, 'both', 'unequal') %2 tailed, unequal
% variances, 5% significance evel
% h = 1 means reject, so different means
% p  very small is probability you see that data, given null hypothesis.
% So a low value is good (different means)        

% sort variables in order best to worst
[ p bestToWorst] = sort( p, 1, 'ascend');

% remove redundancies
unqIdx = findRedundancies( featureVect( bestToWorst,:) );
bestToWorst = bestToWorst(unqIdx);

bestVariables = bestToWorst(1:topVarsToKeep);


