% 
% Syntax:  dataStruct = loadFromTable( tableFile )
% 
% Inputs:
%   tableFile: tab delimited file with column labels
%       subject, trial, gazeX, gazeY, label
%       Labels should be 0 or 1.  
%             label of 2 denotes unknown (exclude trial from analysis)
%       Missing (x,y) coordinates denoted by -1
%       X,Y coordinates scaled in [0,1] range
% 
% Outputs:
%   dataStruct: structure containing the loaded data in a nice format
%       including trackCell,allLabels, and sampsPerSubj

function dataStruct = loadFromTable( tableFile )

% tableFile = 'exampleTable.txt';

% % load (assumes statistics toolbox)
% s = tdfread( tableFile );

% load fix
rawTable = dlmread( tableFile, '\t',1,0);
s.subject = rawTable(:,1);
s.trial = rawTable(:,2);
s.gazeX = rawTable(:,3);
s.gazeY = rawTable(:,4);
s.label = rawTable(:,5);



trackCell = cell(1, max(s.subject)*max(s.trial));
allLabels = zeros( 1, max(s.subject)*max(s.trial));


subs = unique(s.subject); % list of subject numbers
sampsPerSubj = zeros( length(subs),1); % for recording number trials

%loop through each subject
fullIdx = 1;  %for indexing data structure
subjIdx = 1;
for i1 = subs'
   % get data for this subject 
   sIdx = find( s.subject == i1);      
   trial = s.trial(sIdx);
   x = s.gazeX( sIdx );
   y = s.gazeY( sIdx);
   lab = s.label( sIdx);
      
   % split it up by trials
   trList = unique(trial);
   sampsPerSubj(subjIdx)= length(trList); % get number samples
   for i2 = trList'
       trIdx = find( trial == i2);  
       % get gaze(x,i*y) and label
       trackCell{fullIdx} = x( trIdx)+ 1i*y(trIdx);
       allLabels( fullIdx) = lab(trIdx(1));
              
       % increment overallindex
       fullIdx = fullIdx+1;       
   end   
   % increment subject index
   subjIdx = subjIdx+1;   
end

% get data struct for output
trackCell(fullIdx:end) = [];
allLabels(fullIdx:end) = [];
dataStruct.trackCell = trackCell;
dataStruct.allLabels = allLabels;
dataStruct.sampsPerSubj = sampsPerSubj;



