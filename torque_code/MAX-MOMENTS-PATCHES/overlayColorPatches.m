function grayPlusLabels = overlayColorPatches(grayImage, sortedPatches, colorString)
% 
% Move thresholding out?

labelMap = int8(zeros(size(grayImage,1), size(grayImage,2)));

for iCount = 1:size(sortedPatches,1)
	rowCoord = sortedPatches(iCount,1); colCoord = sortedPatches(iCount,2);
	height = sortedPatches(iCount,3); width = height;
	colorIndex = num2str(sortedPatches(iCount,4));
	labelMap = drawMyRect(labelMap, rowCoord, colCoord, [height, width], colorIndex);
end

palette = 'hot'; 
% palette = 'jet';

rgb = label2rgb(labelMap, palette, 'k');

sumRGB = sum(double(rgb), 3);
mask = (sumRGB ~= 0);
mask3D = repmat(mask, [1,1,3]);

grayImage3D = repmat(grayImage, [1,1,3]);

grayImage3D(mask3D) = 0;
grayPlusLabels = rgb + grayImage3D;

figure, imshow(grayPlusLabels);
