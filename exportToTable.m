% This function outputs variables in tab delimited file for further
% analysis
% Samuel Rivera
%  Jun 22, 2014
% syntax: exportToTable( dataStruct, features, file )
% 
% Inputs:
%   dataStruct: returned from 'loadFromTable'
%   featureVect:  (d x N)  matrix of features to export


function exportToTable( dataStruct, features, file )

nSub = length(dataStruct.sampsPerSubj);
subject = cell(nSub,1);
trial = cell(nSub,1);

for i1 = 1:nSub
    subject{i1} = i1*ones( dataStruct.sampsPerSubj(i1),1);
    trial{i1} = (1:dataStruct.sampsPerSubj(i1))';
end
subject = cell2mat( subject);
trial = cell2mat(trial);

% write header
fID = fopen( file, 'w');
fprintf( fID, 'subject\ttrial\tlabel');
for i1 =1:size(features,1)
    fprintf( fID, '\tvar_%d', i1);
end
fprintf( fID, '\n');
fclose(fID);

% write features
dlmwrite( file, [ subject trial dataStruct.allLabels' features' ],'delimiter', '\t', '-append');
