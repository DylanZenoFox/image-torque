function patchHisto = findAllPatchHistos(integralStack, patchSize) 
%
% Given a stack of integral images and a patch size for a square patch
% Generate a stack of 8 images 
% where each pixel value is the sum of counts in the patch centered at that pixel
% This function can also be applied for computing moments inside patches
% e.g. with the call momentPatchHisto = findAllPatchHistos(integralStack, directions, patchSize)
%
% If the patch is straight, the shift directions are [-1, -1; 1, -1; 1, 1; -1, 1]
% If the patch is diagonal, the shift directions are [-1, 0; 0, -1; 1, 0; 0, 1]
% But this is a bit more complicated because diagonal patches have interlaced diagonal cumulations

% 3D shift is needed because the array being shifted is a 3D array

halfSize = floor(0.5 * patchSize);

shiftVectors = [-halfSize,-halfSize; halfSize+1,-halfSize; halfSize+1,halfSize+1; -halfSize,halfSize+1];

patchHisto = zeros(size(integralStack));


for iCount = 1:size(shiftVectors,1)
	shift3D = [shiftVectors(iCount,:), 0]; % 3D vector, but third dimension is always 0 here
	shiftedStack = my3DShift(integralStack, shift3D);
	patchHisto = patchHisto + (-1)^(iCount-1) * shiftedStack; % signs alternate +,-,+,-
end

% disp('Using new findAllPatchHistos');