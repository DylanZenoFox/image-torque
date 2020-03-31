function edgeImage = amitEdgeFinder(im, step, threshold)
% Find locations and directions where gradients are high compared to neighbors

% Inputs: im is a uint8 gray level image; step is how far considered neighbor pixels are (1 or more)
% threshold is used to decide the observed pixel difference is an edge or not 
% Output: an array of 8 logical images stating if an edge GRADIENT exists 
% at orientations N, NE, E, SE, S, SW, W, NW in this order
% pointing from BRIGHT to DARK
% A gradient pointing N (vertical) means the top horizontal edge of a bright spot was found

% 1. Find absolute values of differences between neighbor pixels offset by given step
% for vertical pairs and horizontal pairs (a cross of four segment)
% 2. Find max and min within crosses of four pairs
% 3. There is an edge if the segment that is the max of a cross is the min in a neighbor cross

% Boundaries: use images padded with zeros; the myShift function takes care of that

im = double(im);
[nbRows, nbCols] = size(im);

cross = zeros(nbRows, nbCols, 8);
edgeImage = logical(zeros(nbRows, nbCols, 8)); % eight edge images (see e.g. Fleuret & Geman)

shift   =   step * [1, 0; % N
					0,-1; % E
				   -1, 0; % S
				    0, 1]; % W

for iCount = 1:4
	cross(:,:,iCount) = im - myShift(im, shift(iCount,:)); % shift north pixels down so we can subtract them, etc
end

[maxCross, whichMaxDir] = max(cross,[],3);
[minCross, whichMinDir] = min(cross,[],3);

for iCount = 1:4
	edgeIndex = 2*(iCount-1) + 1; % one of eight
	edgeImage(:,:,edgeIndex) = findGradient(cross, whichMaxDir, whichMinDir, shift(iCount,:), iCount, threshold);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Diagonal edges

shift =     step *  [1,-1; % NE
				   -1,-1; % SE
				   -1, 1; % SW
				    1, 1];% NW

for iCount = 1:4
	cross(:,:,iCount) = im - myShift(im, shift(iCount,:)); % shift north pixels down so we can subtract them
end

[maxCross, whichMaxDir] = max(cross,[],3);
[minCross, whichMinDir] = min(cross,[],3);

for iCount = 1:4
	edgeIndex = 2*iCount;
	edgeImage(:,:,edgeIndex) = findGradient(cross, whichMaxDir, whichMinDir, shift(iCount,:), iCount, threshold);
end

