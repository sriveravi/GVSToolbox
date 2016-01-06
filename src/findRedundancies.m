% finds redundant variables for easy removal
% Feb 25, 2012
% Notes: this funciton checks for redundant variables and returns the index
% of the redundant ones so they can be removed
%
%  inputs:
%     featVect:  (numDim x numSample)  matrix
%     
%  outputs:
%     unqIdx: unique indices
% 

function unqIdx = findRedundancies( featVect  )

[b  unqIdx ] = unique( featVect, 'first', 'rows');
unqIdx = sort( unqIdx, 'ascend');