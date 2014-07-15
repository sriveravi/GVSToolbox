% Samuel Rivera
% Notes: auto gets labels for features usking k-means clustering
%
% syntax: labels = autoLabel( featureVect )
%
% Inputs:
%   featureVect: (d by N) column vector of trials
% 
% Outputs:
%   labels: (1 by N) vector of all labels (0 or 1 )

function labels = autoLabel( featureVect )

numSamples =size(featureVect,2);

featureVect = featureVect - repmat( min( featureVect,[],2), [1,numSamples]);
M = max( featureVect,[],2);
featureVect( M~= 0,:) = featureVect( M~= 0,:)./repmat( M(M~=0), [1,numSamples ] ); 


% featureVect = featureVect - repmat( mean(featureVect,2), [1,numSamples] );
% featStdev = std( featureVect, 0, 2);
% featureVect( featStdev ~= 0,:) = featureVect( featStdev ~= 0,:)./repmat(featStdev(featStdev ~= 0), [1,numSamples]);


labels = kmeans(featureVect',2)-1;
labels = labels';










