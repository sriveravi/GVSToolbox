% Kalman filter missing data from eye track
% Samuel Rivera and Fabian Benitez for Kalman Filtering
% June 24, 2011
% Notes: This function filters eye tracks to smooth and eliminate missing
%       data
%
% Syntax: eyeTrack = filterEyeTrackInfant( eyeTrack )
%
% Inputs: 
%       eyeTrack: (Nx1) vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%           missing data.  The paramters used here work well for data
%           scaled between [0 1]
% 
% Outputs:
%      eyeTrack: the kalman filtered version

function eyeTrack = filterEyeTrackInfant( eyeTrack, smoothParam )
           
% oriEyes = eyeTrack;

%---------------------------------------
%filter using Kalman

eyeTrack = [real(eyeTrack) imag(eyeTrack) ];
eyeTrack( eyeTrack == -1) = nan;

t = ones( 1, length( eyeTrack ) );
t( isnan( eyeTrack(:,1) )) = -1; %mising is -1, filled is 1

if nargin < 2 || isempty( smoothParam)
    smoothParam = .0003;  %  to increase smoothness, lower the number
                      % 1000 empirically works on the up-scaled eye track data
                      % in [.0001 , .0005] empirically works on the data in [ 0 1 ]
end

known = find( t == 1); 
while(known(2)-known(1) >1) %make sure not a single thing, so we can calculate things
    known(1) = [];
end

% Identify the large gaps of missing eye tracks
% don't interpolate the large missing gaps
missingWindow = 4;
interpThese = ones( 1, length( eyeTrack ) );
for i1 =missingWindow:length(interpThese)    
    i1_check = i1 - [missingWindow-1:-1:0];
    if sum( t(i1_check) == -1) == missingWindow
        interpThese( i1_check ) = 0;
    end
end    
% find start/end of the gaps to interpolate
k1 = 1;
inABlock = 0;
for i1 = 1:length(interpThese)    
    if (inABlock==0) && (interpThese(i1) ==1)
        startInterp(k1) = i1;
        inABlock = 1;
    end
    if (inABlock==1) && (interpThese(i1) ==0)
        endInterp(k1) = i1-1;
        inABlock = 0;
        k1 = k1+1;
    end
    % make sure to end at last sample if started already
    if (i1 ==length(interpThese)) && (inABlock==1)
        endInterp(k1) = i1;
    end    
end

% now interpolate just within those blocks of uninterrupted track
for i1 = 1:length( startInterp )
    [eyeTrack1]=kalmanMissingData( eyeTrack(startInterp(i1):endInterp(i1),:)', t(startInterp(i1):endInterp(i1)), smoothParam)';
    eyeTrack(startInterp(i1):endInterp(i1),:) = eyeTrack1;
end

eyeTrack(isnan(eyeTrack)) = -1;
eyeTrack = eyeTrack(:,1)+1i*eyeTrack(:,2);


