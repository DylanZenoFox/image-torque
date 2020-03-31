function [sortedTorqueMaximum,num_max, sortedTorqueMinimum, num_min] = computeTorqueExtremaValueMap_new( valueMap, momentStack, patchList, num )
%
    if nargin < 4
        num = 500;
    end
    
%     [minFlags, maxFlags] = findExtrema( valueMap );
% 
%     maxFlags = (momentStack == repmat(valueMap,[1,1,size(momentStack,3)])) .* repmat(maxFlags,[1,1,size(momentStack,3)]);
%     minFlags = (momentStack == repmat(valueMap,[1,1,size(momentStack,3)])) .* repmat(minFlags,[1,1,size(momentStack,3)]);
%     
%     maxStack = momentStack .*maxFlags;
%     minStack = momentStack .*minFlags;
% 
%     sortedTorqueMaximum = sortPatches( maxStack, patchList, num );
%     sortedTorqueMinimum = sortPatches(-minStack, patchList, num );
bw = zeros(size(valueMap));
bw(find(valueMap(:,:)<-0.199))= 1;
%centroids_new =zeros(num,2);
L = bwlabel(bw);
s  = regionprops(L, 'Centroid','FilledArea');
area = cat(1, s.FilledArea);
centroids = cat(1, s.Centroid);
[area_new, area_index]= sort(area, 'descend');
num2 = min(num, size(s,1));
num_max = num2;
num_min = num2;
sortedTorqueMinimum =zeros(num2,2);
sortedTorqueMaximum =zeros(num2,2);
centroids_new(1:num2,:) = centroids(area_index(1:num2),:);
sortedTorqueMinimum = double([centroids_new(:,2), centroids_new(:,1)]);
sortedTorqueMaximum = double([centroids_new(:,2), centroids_new(:,1)]);
% figure;
% imagesc(valueMap);
% axis image; axis off; colormap jet
% figure;
% imagesc(L);
% axis image; axis off; colormap gray
% hold on
% plot(centroids_new(:,1), centroids_new(:,2), 'b*')
% hold off