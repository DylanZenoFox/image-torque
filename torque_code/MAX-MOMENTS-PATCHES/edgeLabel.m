function labelImage = edgeLabel(edges)
% Find single image with edge pixels labeled and colored according to gradient direction
%

labelImage = int8(zeros(size(edges,1), size(edges,2)));

for iCount = 1:size(edges,3)
    labelImage(edges(:,:,iCount)) = iCount;
end

% palette = 'hot';
palette = 'jet';

rgb = label2rgb(labelImage, palette);

figure, imshow(rgb);

