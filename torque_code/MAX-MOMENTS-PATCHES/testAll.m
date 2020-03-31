function testAll(fileName)
%
% Read an image and test edge finding, 
% integral edge image, 
% patch histograms for edges,
% integral moment image,
% and patch histograms for moments

% Sum up values of moments wrt top left corner of image in 8 directions
% in order to speed up calculations of histograms of moments in ROIs
% See details of moment calculations in integralMomentImage.m

% fileName = 'natalieAndMe.jpg';

% 0. Read and show image

useDiagonal = 0 % the part using square patches at 45 degrees is not complete because of issues with diagonal integral images

testImage = imread(fileName);
imSize = size(testImage);
colorDepth = size(imSize);
if colorDepth(2) == 3
	testImage = rgb2gray(testImage);
end

nbRows = imSize(1); 
nbCols = imSize(2);

if 1 % if set to 0, skip calculations of scale moment stack

	figure, imshow(testImage);
	
	% 1. Set up parameters
	% step = 2
	minDim = min(nbRows, nbCols);
	step = round(minDim/300); % step is 1 for 300 pix, 2 for 600; TEST OTHER MAPPINGS
	if step<1
		step = 1; % prevents step from being zero for small images
	end
	threshold = 20
	step
	
	% 2. Find edge gradients
	% edges = amitEdgeFinder3(testImage, step, threshold);
	edges = amitEdgeFinder(testImage, step, threshold); % array of 8 logical 2D arrays showing where edges are
	
	if 1
		labelImage = edgeLabel(edges); % Label and show edges 
%		labelImage = overlayEdgeLabels(testImage, edges); % Label and show edges on top of gray image
	end
	
	% 3. Multiple edges on single pixels are given half the weight 
	weights = findWeights(edges); % find weights of pixels, giving lower weights to pixels with more edges
	replicatedWeights = repmat(weights, [1 1 8]);
	weightedEdges = edges .* replicatedWeights;
	
	% 4. Compute integral edge image
if useDiagonal
	sumEdges = diagonalIntegralStackImage(weightedEdges);
else
	sumEdges = integralStackImage(weightedEdges);
end
	
	% 5. Compute integral edge moments
	momentArms = makeMomentArms(nbRows, nbCols);
	moments = momentArms .* weightedEdges;
if useDiagonal
	sumMoments = diagonalIntegralStackImage(moments);
else
	sumMoments = integralStackImage(moments);
end	
	% 6. Find location of min and max in scale stack and values of stack at these extrema
if useDiagonal
	patchList = makeDiagPatchList(nbRows, nbCols); % list of patch sizes corresponding to different scales
	scaleStack = findDiagMomentScaleStack(momentArms, sumEdges, sumMoments, patchList);
else
	patchList = makePatchList(nbRows, nbCols); % list of patch sizes corresponding to different scales
	scaleStack = findMomentScaleStack(momentArms, sumEdges, sumMoments, patchList);
end	
	
	% 7. THRESHOLD SCALE STACK
	threshold = 0.5;
	thresholdFlags = (abs(scaleStack) < 0.5);
	scaleStack(thresholdFlags) = 0;

	save scaleStack2.mat patchList scaleStack;

end

load scaleStack2.mat patchList scaleStack; % we save and reload so we can restart script from here

% 8. Find maxima in moment scale stack
disp('Find maxima in moment scale stack'); 
maxFlags = find3DMax(scaleStack, patchList);
minFlags = find3DMax(-scaleStack, patchList);

maxStack = scaleStack .*maxFlags;
minStack = scaleStack .*minFlags;

sortedBrightPatches = sortPatches(maxStack, patchList, 500); % Are largest areas the most stable for recognition? CHECK
sortedDarkPatches = sortPatches(-minStack, patchList, 500); % Largest areas are best enveloped by square, Less freedom

% markedImage = drawSortedPatches(testImage, sortedBrightPatches, 'lightGray');
% markedImage = drawSortedPatches(testImage, sortedDarkPatches, 'darkGray');
markedImage = overlayColorPatches(testImage, sortedBrightPatches);
markedImage = overlayColorPatches(testImage, sortedDarkPatches);

disp('Stop here');
if 0

% 9. Create patch descriptors represented by star fields of local subpatch locations
disp('Create Bright Star Fields');
minMomentValue = sortedBrightPatches(end, 5);
brightStarFields = findMultiScaleStarFields(maxStack, patchList, minMomentValue);

disp('Create Dark Star Fields');
minMomentValue = sortedDarkPatches(end, 5); % negative
darkStarFields = findMultiScaleStarFields(-minStack, patchList, minMomentValue);

starFieldFile = [fileName, '.mat'];
save(starFieldFile, 'brightStarFields', 'darkStarFields');

% if 0

	% 9. Stack sum of edge maps for all directions on top of other edge maps
	allEdges = sum(weightedEdges, 3);
	
	edgeStack = zeros(size(edges) + [0,0,1]); % make one additional slot in third dimension
	edgeStack(:,:,1:end-1) = weightedEdges;
	edgeStack(:,:,end) = allEdges;
	
	% 8. Make integral moment images for edgeStack
	[sumM00, sumM10, sumM01, sumM20, sumM02, sumM11] = makeAllIntegralMoments(edgeStack);
	
	% 9. Find features
	
	labelMap = uint8(zeros(size(markedImage)));
	
	for iCount = 1:size(sortedBrightPatches,1)
		features = findFeatures(sumM00, sumM10, sumM01, sumM20, sumM02, sumM11, sortedBrightPatches(iCount,:), markedImage);
		labelMap = labelEllipses(labelMap, features);
	end
	
	
	grayPlusLabels = overlayEdgeLabels2(markedImage, labelMap);
	
end

