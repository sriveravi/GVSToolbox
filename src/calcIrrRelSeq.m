% convert the fixation or saccade sequence to a representation in terms of relevant and irrelevant AOIs
% 
% Syntax: sequence = calcIrrRelSeq( AOISequence, relAOIs ) 
% 
% Inputs:
%  AOISequence: matrix (numAOI x number in sequence) with an indicator (1) for
%       in each column corresponding to the AOI of interest.  If no
%       AOI, it will be all 0;
% 
%  relAOIs: index of AOIs which we are interested in
% 
% Outputs:
%  sequence: matrix ( 2 x numSeq ) where each column corresponds to an AOI
%       visit.  first row is 1 if relevant, 2nd is 1 of irrelevant, and
%       both are 0 if no AOIs visited.
% 

function sequence =calcIrrRelSeq( AOISequence, relAOIs ) 


numInSeq = size(AOISequence,2);
sequence = zeros( 2, numInSeq );

for i1 = 1:numInSeq 
    % if an AOI look found, check if relevant or irrelevant
    if sum( AOISequence(:,i1))
        aoiIdx = find(AOISequence(:,i1) ==1 );        
        if sum( aoiIdx == relAOIs )            
            sequence( 1,i1) = 1;            
        else
            sequence( 2,i1) = 1;
        end
    end             
end



    

