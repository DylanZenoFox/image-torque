function [sortedTorqueMaximum, sortedTorqueMinimum] = computeTorqueExtremaValueMap( valueMap, momentStack, patchList, num )
%
    if nargin < 4
        num = 500;
    end
    
    [minFlags, maxFlags] = findExtrema( valueMap );

    maxFlags = (momentStack == repmat(valueMap,[1,1,size(momentStack,3)])) .* repmat(maxFlags,[1,1,size(momentStack,3)]);
    minFlags = (momentStack == repmat(valueMap,[1,1,size(momentStack,3)])) .* repmat(minFlags,[1,1,size(momentStack,3)]);
    
    maxStack = momentStack .*maxFlags;
    minStack = momentStack .*minFlags;

    sortedTorqueMaximum = sortPatches( maxStack, patchList, num );
    sortedTorqueMinimum = sortPatches(-minStack, patchList, num );
