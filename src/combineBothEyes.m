% combine gaze data from two eyes into one by averaging
% July 5, 2011
% Notes: combine the left and right eye track
% 
% Syntax: eyePos = combineBothEyes( leftEyePos, rightEyePos )
% 
% Input:
%   leftEyePos: left eye tracking data, (Nx1) vector  of complex (x+i*y) 
%       coordinates.  -1-i1 or nan-inan  to identify missing data.
%   rightEyePos: just like for right eye track
% 
% Output:
%   eyePos: the mean eye track

function eyePos = combineBothEyes( leftEyePos, rightEyePos )

% vector of all 1's
leftKnown = ones( size( leftEyePos ));
rightKnown = ones( size( leftEyePos )); 

% make 0 if -1, or nan
leftKnown( real(leftEyePos) == -1 ) = 0;
leftKnown( isnan(real(leftEyePos))) = 0;   
rightKnown( real(rightEyePos) == -1 ) = 0;
rightKnown( isnan(real(rightEyePos))) = 0;
known = find( leftKnown+rightKnown == 2); % both known

eyePos = -1*ones( size(leftEyePos));
eyePos( known ) = (leftEyePos(known) + rightEyePos(known))/2;









