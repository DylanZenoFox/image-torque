function image = drawMyRect(image, row, col, patch, colorString) 
%
% Draw a rectangle at pixel (row, col) of height patch(1) and width patch(2)

if strcmp(colorString, 'black')
	grayValue = 0;
elseif strcmp(colorString, 'darkGray')
	grayValue = 100;
elseif strcmp(colorString, 'lightGray')
	grayValue = 200;
elseif strcmp(colorString, 'white')
	grayValue = 255;
else % string represents gray level value directly
	grayValue = str2num(colorString);
end

halfPatch = floor(patch/2);
nbImRows = size(image,1);
nbImCols = size(image,2);

topLeft = [row,col] - halfPatch;
botRight = topLeft + patch;
topRight = [topLeft(1), botRight(2)];
botLeft = [botRight(1), topLeft(2)];

if topLeft(2)>=1 && topLeft(2)<=nbImCols
	for iRow = topLeft(1):botLeft(1)
		if iRow<1 || iRow>nbImRows
			continue
		end
		image(iRow,topLeft(2)) = grayValue;
	end
end

if topRight(2)>=1 && topRight(2)<=nbImCols
	for iRow = topRight(1):botRight(1)
		if iRow<1 || iRow>nbImRows
			continue
		end
		image(iRow,topRight(2)) = grayValue;
	end
end

if topLeft(1)>=1 && topLeft(1)<=nbImRows
	for iCol = topLeft(2):topRight(2)
		if iCol<1 || iCol>nbImCols
			continue
		end
		image(topLeft(1),iCol) = grayValue;
	end
end

if botLeft(1)>=1 && botLeft(1)<=nbImRows
	for iCol = botLeft(2):botRight(2)
		if iCol<1 || iCol>nbImCols
			continue
		end
		image(botLeft(1),iCol) = grayValue;
	end
end
