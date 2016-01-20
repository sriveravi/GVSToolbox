% Syntax:  dataStruct = smoothTracks( dataStruct )
% 
% Inputs:
%   dataStruct = structure of loaded gaze data returned from
%         loadFromTable function. Note that we assume missing
%         entries initially denoted by -1, and gaze scaled in [0,1]
% 
%   smoothParam = parameter for kalman filter. Increase smoothness with
%       lower number.  1000 empirically works on the up-scaled eye track data
%       in [.0001 , .0005] empirically works on the data in [ 0 1 ] 
% 
% Outputs:
%   dataStruct: structure containing the smoothed and interpolated gaze

function dataStruct = smoothTracks( dataStruct, smoothParam )

if nargin < 2
    smoothParam = [];  % making empty will set to default in the filterEyeTrackInfant function
end

tracks = dataStruct.trackCell;
for i1 = 1:length( tracks)
    tr = filterEyeTrackInfant( tracks{i1}, smoothParam );
    dataStruct.trackCell{i1} = tr;
end
    
