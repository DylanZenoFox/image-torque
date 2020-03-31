function sortedPatches = sortPatches(stack, patchList, nbPatches)
%
% Sort patches by area value in stack
% Descending order
% sortedPatches has one patch per row
% listing row, col, patch height, patch width, scale and moment value
% scales defines the index in the third dimension of the stack, 
% patchList gives the actual size of the square patches at each of the scales indices

[sortedValues, indexMap] = sort(stack(:), 1, 'descend'); % sort in descending order.
nonZeroValueIndices = find(sortedValues ~= 0);
nbNonZeroMoments = length(nonZeroValueIndices);
nbPatches = min(nbNonZeroMoments, nbPatches); % do not keep zero elements

[rows, cols, scales] = ind2sub(size(stack), indexMap); % replace linear indexMap with 3D version

shortScaleList = scales(1:nbPatches,:);
shortPatchList = patchList(shortScaleList); 

sortedPatches = [rows(1:nbPatches,:), cols(1:nbPatches,:), shortPatchList(:), shortScaleList(:), sortedValues(1:nbPatches)];