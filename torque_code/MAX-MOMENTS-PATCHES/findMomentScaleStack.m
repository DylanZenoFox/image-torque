function scaleStack = findMomentScaleStack(momentArms, sumEdges, sumMoments, patchList)
%
% Find 3D stack of moments over different patch sizes listed in patchList
% Moments are wrt to patch centers, not image corner

nbScales = size(patchList,1);
[nbRows, nbCols, nbDirs] = size(sumEdges);
scaleStack = zeros(nbRows, nbCols, nbScales); 

for iScale = 1:nbScales
	iScale;
	patchSize = patchList(iScale);
	edgePatchHisto = findAllPatchHistos(sumEdges, patchSize);
	momentPatchFromCorner = findAllPatchHistos(sumMoments, patchSize);
	momentPatchHisto = momentPatchFromCorner - momentArms .* edgePatchHisto;	% arms from pixel to top left corner
    allDirMomentHisto = sum(momentPatchHisto, 3); % sum 8 moments
%	normalizer = sum(abs(allDirMomentHisto(:)))/nbPixels; % average all-direction moment FOR THIS SCALE; note the abs
	if 0
%		normalizer = 2*patchSize*patchSize*patchSize/6.0; % max area moment for the patch:Small patches only
		edgeCount = sum(edgePatchHisto, 3); % sum 8 histogram bins to get total edge count
    	scaleStack(:,:,iScale) = allDirMomentHisto ./ edgeCount; % radial moment normalized by edge count  
    else
%   	normalizer = max(max(abs(allDirMomentHisto))); % max moment FOR THIS SCALE
		normalizer = 2*patchSize * patchSize; % max silhouette moment for the patch; BEST 1/13/2008   
    	scaleStack(:,:,iScale) = allDirMomentHisto/normalizer; % normalized radial moment   
   	end
end



