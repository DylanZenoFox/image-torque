clear
close all

addpath MAX-MOMENTS-PATCHES
dir =  'C:\Data\matlab\torque\codeTorque1\filter-training\wine-glass1\';
dir =  'C:\Data\Images\tool-images\';
%image_name = [dir, 'salad-fork_1310354824.725504_RGB.png'];
image_name = [dir, 'DSCN3949.jpg'];
im = imread(image_name);
%im = imread( '101085.jpg' );
%im = imread( 'rgb_image_small.png' );
    
% edge detection
thresh = [];    % adjust thresh
edges = computeCannyEdge( im, thresh );

% compute torque maps
patchList = (3:2:45)';
%patchList = (3:4:31)';
momentStack = computeTorque( edges, patchList );

% compute scale map and value map
[scaleMap, valueMap, momentStackMin, momentStackMax] = findMaxMinTorqueScale( momentStack, patchList );

% find extrema in torque volume
[torqueMax, torqueMin] = computeTorqueExtrema( momentStack, patchList );

% find extrema in value map
[torqueMaxValueMap, torqueMinValueMap] = computeTorqueExtremaValueMap( valueMap, momentStack, patchList );

% stregthened edges
edgeContMaximum = computeEdgeContribution( edges, [torqueMax(:,2),torqueMax(:,1)], torqueMax(:,3) );
edgeContMinimum = computeEdgeContribution( edges, [torqueMin(:,2),torqueMin(:,1)], torqueMin(:,3) );

%
% display
%

% image
figure;
imshow( im );
title( 'test image' )

% edges
figure;
imagesc( sum(edges,3) );
title( 'edge map' );

% value map with extrema
valueMapMax = max( valueMap(:) );
valueMapMin = min( valueMap(:) );
if valueMapMax >= -valueMapMin
    valueMapMin = -valueMapMax;
else
    valueMapMax = -valueMapMin;
end
imagesc( valueMap, [valueMapMin, valueMapMax] );
axis image; axis off; colormap jet
hold on
for j=1:3%size( torqueMaxValueMap, 1 )
     plot( torqueMaxValueMap(j,2), torqueMaxValueMap(j,1), 'wx', 'markersize', 11, 'linewidth', 3 );
 end
for j=1:3%size( torqueMinValueMap, 1 )
    plot( torqueMinValueMap(j,2), torqueMinValueMap(j,1), 'kx', 'markersize', 11, 'linewidth', 3 );
end
title( 'value map with extrema: white x is positive and black x is negative' );

%stregthened edges
figure;
imagesc(  sum(edgeContMaximum,3), [0,max(max(sum(edgeContMaximum,3)))] );
axis image; axis off; colormap gray
title( 'strengthened edges by positive torque' );

figure;
imagesc( -sum(edgeContMinimum,3), [0,max(max(sum(-edgeContMinimum,3)))]  );
axis image; axis off; colormap gray
title( 'strengthened edges by negative torque' );
