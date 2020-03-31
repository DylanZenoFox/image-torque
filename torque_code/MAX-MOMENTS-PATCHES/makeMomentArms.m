function momentArms = makeMomentArms(nbRows, nbCols)
% Moment arms from top left corner of image to edges 
% for edge gradients at each pixels in directions N, NE, E, SE, S, SW, W, NW
% in that order

halfSqrt2 = 0.5*sqrt(2);
pixelRows = repmat((1:nbRows)',[1,nbCols]); % row indices of all image pixels
pixelCols = repmat((1:nbCols),[nbRows,1]); % col indices of all image pixels 

% Unit vectors for 8 directions of moment arms for 8 edge gradient directions
armDirections = [ -1,         0;            % N: if edge gradient is N, edge vector with bright on right side is left to right, and arm is downward
                  -halfSqrt2, halfSqrt2;    % NE
                   0,         1;            % E
                   halfSqrt2, halfSqrt2;    % SE
                   1,         0;            % S
                   halfSqrt2,-halfSqrt2;    % SW
                   0,        -1;            % W
                  -halfSqrt2,-halfSqrt2];   % NW
                  
for iCount = 1:8
    momentArms(:,:,iCount) = armDirections(iCount,1)*pixelRows + armDirections(iCount,2)*pixelCols;
end
