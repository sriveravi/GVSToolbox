%  scale eye track from [0 1] to image size
% 
% This function scales the eye track (from between [0+i0, 1+i1]) to the
%       size corresponding to the display, taking care not to change the -1
%       values corresponding to missing data.
% 
% syntax:  eyeTrack = scaleEyeTrack( eyeTrack, imageSize )
% 
% inputs: 
%   eyeTrack: vector  of complex (x+i*y) coordinates.  -1-i1  to identify
%           missing data. 
%   imageSize: [height; width], probably  [1024; 1280];
% 
% output:
%   eyeTrack: the appropriately scaled version

function [ eyeTrack imageSize ] = scaleEyeTrack( eyeTrack, imageSize  )

%default scaling amount
if nargin < 2 || isempty( imageSize)
    imageSize =   [1024; 1280];
end


xEye = real( eyeTrack ); 
yEye = imag(eyeTrack); 
existSamples = find(xEye ~= -1 );
xEye( existSamples) = xEye( existSamples).*imageSize(2);


% yEye( existSamples) = abs( yEye( existSamples)-1);  %flip vertically
yEye( existSamples) = yEye( existSamples).*imageSize(1);




eyeTrack = xEye+1i*yEye;

