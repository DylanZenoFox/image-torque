function maxFlags = find3DMax(stack, patchList)
%
% Given stack of images obtained by patches of increasing scale from top to bottom
% Find locations of pixels that are maxima both in plane of images
% and in scale (third dimension of stack)
% Note: it does not make sense to say that the max point should be some threshold more than its neighbors
% The reason is that maxima are regions where the derivative is zero, 
% and therefore the value at the point is almost the same as at its neighbors

if 1
shifts3D = 		   [3, 0, 0; % check far
					0,-3, 0; 
				   -3, 0, 0;
				    0, 3, 0;
 		   			2, 0, 0; % check close too
					0,-2, 0; 
				   -2, 0, 0;
				    0, 2, 0;
 		   			1, 0, 0; % check close too
					0,-1, 0; 
				   -1, 0, 0;
				    0, 1, 0;
					0, 0, 1; % check 2 neighbor scales
					0, 0,-1];
else
shifts3D = 		   [5, 0, 0; % check far
					0,-5, 0; 
				   -5, 0, 0;
				    0, 5, 0;
 		   			3, 0, 0; % check close too
					0,-3, 0; 
				   -3, 0, 0;
				    0, 3, 0;
 		   			1, 0, 0; % check close too
					0,-1, 0; 
				   -1, 0, 0;
				    0, 1, 0;
					0, 0, 1; % check 2 neighbor scales
					0, 0,-1];
end
verticalShifts = [0,1,-1];

stackDim = size(stack);
maxFlags = logical(ones(stackDim));

for iShift = 1:size(shifts3D,1)
    dir3D = shifts3D(iShift,:);
    shiftedStack = my3DShift(stack, dir3D);
    maxFlags = maxFlags & (stack>shiftedStack);
end

% thresholdedStack = abs(stack) > 0.5; % MOVE THIS OUT TO THE OPEN
% maxFlags = maxFlags & thresholdedStack;

% remove maxima caused by edge effects
maxFlags(:,:,1)=0;
maxFlags(:,:,end)=0;
for iScale = 1:size(patchList,1)
	borderSize = round(patchList(iScale)/2); % half size of patch	
	maxFlags(1:borderSize,:,iScale)=0; 
	maxFlags(end-borderSize+1:end,:,iScale)=0;
	maxFlags(:,1:borderSize,iScale)=0;
	maxFlags(:,end-borderSize+1:end,iScale)=0;
end
