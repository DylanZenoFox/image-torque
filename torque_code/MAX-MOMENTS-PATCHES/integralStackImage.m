function sumStack = integralStackImage(imageStack) 

% Input: imageStack(:,:,:) is a stack of images
 
% Output: sumStack(:,:,:) is a stack of integral images

% Integral images for edges sum up to 1000 x 1000
% Order 1 moments for 1000 x 1000 images can sum up to 10^9
% Order 2 moments can sum up to 10^12; need to use double. int64 does not have addition operation

% CHECK: float arithmetic may be faster

sumCols = zeros(size(imageStack)); % used to sum edges column by column
sumStack = zeros(size(imageStack)); % used to sum sumColsEdges row by row

[nbRows,nbCols] = size(imageStack(:,:,1));

sumCols(:,1,:) = imageStack(:,1,:); % first column of sumColsEdges is same as edges
for iCol = 2:nbCols
    sumCols(:,iCol,:) = sumCols(:,iCol-1,:) + imageStack(:,iCol,:);
end

sumStack(1,:,:) = sumCols(1,:,:); % first row of sumRowsEdges is same as sumColsEdges
for iRow = 2:nbRows
    sumStack(iRow,:,:) = sumStack(iRow-1,:,:) + sumCols(iRow,:,:);
end
    

