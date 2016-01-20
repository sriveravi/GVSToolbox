% This function tells you which variables are best in an easy to understand format
% Samuel Rivera
% Jul 20, 2011
% syntax: describeVariables( varParams, bestIdx )
% 
% Inputs:
% varParams: the struct returnd by extractVarsDist ( when you extracted
%   variables)
% bestIdx: a vector of the best indices as determined by the sortVariable**
%   functions.  
% 
function describeVariables( varParams, bestIdx )



numAOIs = varParams.dimPerFeat(1);  % var 1 is AOI fix density
% % numRelAOIs = varParams.dimPerFeat(5)/varParams.numHistBins;% var 5 is hist bins
% % numBins = varParams.numHistBins;

clear x whereItIs
numBest = length( bestIdx );
numVariableTypes = length( varParams.dimPerFeat);

for i1 = 1:numVariableTypes
    x(i1) = sum(varParams.dimPerFeat(1:i1));
end

whereItIs = zeros( numBest,1);
for i1 = 1:numBest
    temp = find( bestIdx(i1) <= x );
    whereItIs(i1) = temp(1);
end

for i1 = 1:numBest    
    % find exact variable within the variable type ( ie, 2nd fixation density)
    if whereItIs(i1) > 1
        subWhereItIs(i1) = bestIdx(i1) - x( whereItIs(i1) -1);
    else
        subWhereItIs(i1) = bestIdx(i1);
    end   
    
    %output very nicely which variable
    if strcmp( varParams.dimNames{whereItIs(i1)}, 'AOIFixationSeq' ) %fixation sequence        
        whichPos = mod( subWhereItIs(i1), numAOIs);
        if whichPos == 0; whichPos =numAOIs; end
        whichFix = ceil( subWhereItIs(i1)/numAOIs );
        fprintf( 'Var %d is Fix %d at AOI %d \n', i1, whichFix, whichPos);    
    
    elseif strcmp( varParams.dimNames{whereItIs(i1)}, 'AOISaccadeSeq' )
        whichPos = mod( subWhereItIs(i1), numAOIs);
        if whichPos == 0; whichPos =numAOIs; end
        whichFix = ceil( subWhereItIs(i1)/numAOIs );
        fprintf( 'Var %d is Sac %d to AOI %d \n', i1, whichFix, whichPos);      
        
% %    elseif strcmp( varParams.dimNames{whereItIs(i1)}, 'AOIFixationDistHistogram' )     
% %         whichPos = mod( subWhereItIs(i1), numBins);
% %         if whichPos == 0; whichPos =numBins; end
% %         whichAOI = ceil( subWhereItIs(i1)/numBins );
% %         fprintf( 'Var %d is rel AOI %d, DHB %d \n', i1, whichAOI, whichPos);   
% %         
        
    elseif strcmp( varParams.dimNames{whereItIs(i1)}, 'relNonRelFixSeq' )  
        target = 'relevant';
        whichPos = mod( subWhereItIs(i1), 2);
        if whichPos == 0; target = 'non-relevant'; end
        whichFix = ceil( subWhereItIs(i1)/2 );
        fprintf( 'Var %d is Fix %d at %s AOI \n', i1, whichFix, target);          
 
                
    elseif strcmp( varParams.dimNames{whereItIs(i1)}, 'relNonRelSacSeq' )  
        target = 'relevant';
        whichPos = mod( subWhereItIs(i1), 2);
        if whichPos == 0; target = 'non-relevant'; end
        whichFix = ceil( subWhereItIs(i1)/2 );
        fprintf( 'Var %d is Sac %d to %s AOI \n', i1, whichFix, target);     
        
    else % default output
        fprintf( 'Var %d is feat %d of %s\n', i1, subWhereItIs(i1), ...
                varParams.dimNames{whereItIs(i1)});        
    end
    
end





