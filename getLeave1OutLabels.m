% get a struct for specifying folds of leave one out cross validation
% notes: return an array of the train/testing indices for leave 1 subject
% out cross validation.  It wassumes samples from 1 subject are stored 
% adjacent to each other
% 
% syntax: trainTesTLabels = getLeave1OutLabels( numSamples, numPer1Subj )
%
% Input:
%   numSamples: total number of data samples
%   numPer1Subj: vector of number of consecutive samples for each subject.
%       If it is a constant amount of each subject, then you can just
%       specify that constant integer
% 
% Outputs:
%   trainTesTLabels: struct array of train/test indices,
%       trainTesTLabels(1).test, or trainTesTLabels(1).train

function trainTesTLabels = getLeave1OutLabels( numSamples, numPer1Subj )

if length(numPer1Subj) == 1  %if fixed number
    numTrials = numSamples/numPer1Subj;
    for i1 = 1:numTrials
        i1_test = i1*numPer1Subj - [numPer1Subj-1:-1:0];    
        trainTesTLabels(i1).test = i1_test;
        trainTesTLabels(i1).train = 1:numSamples;
        trainTesTLabels(i1).train(i1_test) = [];           
    end
    
else        %different number in each block, the case for infants 
    numTrials = length(numPer1Subj);    
    trainTesTLabels(1).test =1:numPer1Subj(1);
    trainTesTLabels(1).train =  (numPer1Subj(1)+1):numSamples;
    for i1 = 2:numTrials        
        i1_test = (sum(numPer1Subj(1:i1-1))+1):sum(numPer1Subj(1:i1));
        trainTesTLabels(i1).test =i1_test;
        trainTesTLabels(i1).train = 1:numSamples;
        trainTesTLabels(i1).train(i1_test) = [];           
    end
    
    
end