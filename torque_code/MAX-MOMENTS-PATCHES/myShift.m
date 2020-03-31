	function shifted = myShift(im, shiftVector) 

% Shift image by shiftVector(1) rows and shiftVector(2) cols
% These can be positive or negative
% Returns same format as image came in
% Note: the image itself is translated by shiftVector, NOT the observation point in the image

% Pad array with zeros using padarray
absShift = abs(shiftVector);
paddedIm = padarray(im, absShift);
paddedSize = size(paddedIm);

% Circle-shift image
circleShifted = circshift(paddedIm, shiftVector);
% Truncate circleShifted to remove extra padding and get back to image size
shifted = circleShifted(absShift(1)+1:paddedSize(1)-absShift(1), absShift(2)+1:paddedSize(2)-absShift(2));


