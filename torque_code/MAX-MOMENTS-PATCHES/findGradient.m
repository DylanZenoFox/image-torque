function gradient = findGradient(cross, whichMaxDir, whichMinDir, shiftDir, dirIndex, threshold)
%
% Find if there is a gradient in direction shiftDir (one of 4) at each pixel
% Inputs: cross is stack of 4 differences of pictures with neighbors
% whichMaxDir is direction of maximum difference
% whichMinDir is direction of minimum difference
% The max and the min differences must point to the same segment between two pixels
% shiftDir is vector for gradient direction (N is [1, 0], E is [0, -1], etc)
% dirIndex is index of direction (N is 1, E is 2, etc)

oppositeDirIndex = mod(dirIndex + 1, 4) + 1;
crossSegment = cross(:,:,dirIndex);
shiftedWhichMinDir = myShift(whichMinDir, shiftDir);
gradient = (whichMaxDir == dirIndex) & (shiftedWhichMinDir == oppositeDirIndex);
gradient = gradient & (crossSegment > threshold); % We want pixel value to be higher than at dirIndex
