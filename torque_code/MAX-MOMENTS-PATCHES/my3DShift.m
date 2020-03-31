function shiftedStack = my3DShift(stack, shift3DVector) 

absShift = abs(shift3DVector);
% Shift stack by shift3DVector(1) rows, shift3DVector(2) cols and shift3DVector(3) layers
% These can be positive or negative
% Use same format as stack came in
% Note: the image itself is translated by shiftVector, NOT the observation point in the image

% Pad array with zeros using padarray
absShift = abs(shift3DVector);
paddedStack = padarray(stack, absShift, 'replicate', 'both');
% paddedSize = size(paddedStack);

% Circle-shift image
circleShifted = circshift(paddedStack, shift3DVector);
% Truncate circleShifted to remove extra padding and get back to stack size
% shiftedStack = circleShifted(absShift(1)+1:paddedSize(1)-absShift(1), ...
%						absShift(2)+1:paddedSize(2)-absShift(2), ....
%						absShift(3)+1:paddedSize(3)-absShift(3));
shiftedStack = circleShifted(absShift(1)+1:end-absShift(1), ...
						absShift(2)+1:end-absShift(2), ....
						absShift(3)+1:end-absShift(3));
