function myImShow(myArray) 
%
% Display a 2D array as an image after normalizing it
	maxVal = max(myArray(:));
	minVal = min(myArray(:));
	figure, imshow(uint8((myArray-minVal)*255/(maxVal-minVal)));
end