function patchList = makePatchList(nbRows, nbCols) 
% Return a list of patch sizes for square patches
% from smallest to largest
% This list is used both by findBestPatches and findBestSecondMomentPatches

smallerDim = min(nbRows,nbCols);
minPatchDim = floor(smallerDim/50);
minPatchDim = max(minPatchDim, 4); % we limit size of minPatchDim to 4 pixels
% smallerDim is divided by sqrt(2) so that there are as many diagonal patches as straight ones
maxPatchDim = 0.8 * smallerDim / sqrt(2); 

scale = 1;
nbOctaves = 5;
nbScalesPerOctave = 3;
nbScales = nbOctaves*nbScalesPerOctave + 1;

scaleFactor = 2^(1/nbScalesPerOctave); 

patchList = [];

for iScale = 1:nbScales
	patch = round(scale * minPatchDim);
	if patch == 2*floor(patch/2)
		patch = patch+1;
	end
	if patch > maxPatchDim
		break; % done
	end
	patchList = [patchList; patch];
	scale = scale * scaleFactor;
end
