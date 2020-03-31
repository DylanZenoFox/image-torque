function [sortedTorqueMaximum, sortedTorqueMinimum] = computeTorqueExtrema( momentStack, patchList )
%
    maxFlags = find3DMax( momentStack, patchList);
    minFlags = find3DMax(-momentStack, patchList);

    maxStack = momentStack .*maxFlags;
    minStack = momentStack .*minFlags;

    sortedTorqueMaximum = sortPatches( maxStack, patchList, 750);
    sortedTorqueMinimum = sortPatches(-minStack, patchList, 750);
