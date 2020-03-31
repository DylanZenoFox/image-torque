function fixation_points = torque_set

% returns the fixation points as a n x 1 cell structure, which each
% cell an array of the form : row, col coordinates 
%  currently it returns up to 4 fixation points per image
% 
num_fix_points = 4;
close all
addpath MAX-MOMENTS-PATCHES
%imsdir =  'C:\Data\matlab\torque\codeTorque1\filter-training\test-images\';
imsdir =  'C:\Data\matlab\torque\codeTorque1\objs-actions\';
Aims    = dir([imsdir '/*.png']);
%fixation_points = zeros(length(Aims)*num_fix_points, 2);
fixation_points = {[]};

for i = 1:length(Aims)
    imname = [imsdir, Aims(i).name];
    im1_double = imread(imname); 
    im1 = imresize(im1_double,0.5);

    
% use only the table
% size =[ miny, maxy, minx, maxx];
  % size for 2-3 objects
%  size =[ 183 235 57 316]
  size =[ 175 240 57 316]
 % size for image twice the size
 % size = [357 480 110 640]
  % size for many objects
  % size =[ 176, 240, 21, 320];
  
 im = im1(size(1):size(2), size(3):size(4), :);
% edge detection
    thresh = [];    % adjust thresh
    edges = computeCannyEdge( im, thresh );

    % compute torque maps
    %patchList = (3:2:45)';
    patchList = (3:4:29)';
    momentStack = computeTorque( edges, patchList );

    % compute scale map and value map
    [scaleMap, valueMap, momentStackMin, momentStackMax] = findMaxMinTorqueScale( momentStack, patchList );

    % find extrema in torque volume
    [torqueMax, torqueMin] = computeTorqueExtrema( momentStack, patchList );

    % find extrema in value map
    [torqueMaxValueMap,num_max, torqueMinValueMap, num_min] = computeTorqueExtremaValueMap_new( valueMap, momentStack, patchList,num_fix_points );
    %[torqueMaxValueMap, torqueMinValueMap] = computeTorqueExtremaValueMap( valueMap, momentStack, patchList );

    % stregthened edges
    edgeContMaximum = computeEdgeContribution( edges, [torqueMax(:,2),torqueMax(:,1)], torqueMax(:,3) );
    edgeContMinimum = computeEdgeContribution( edges, [torqueMin(:,2),torqueMin(:,1)], torqueMin(:,3) );

    %
    % display
    %

    % image
    
    figure;
  % subplot(1,2,1);
    imshow( imresize(im,2) );
  %  title( 'test image' );
  

    % value map with extrema
    valueMapMax = max( valueMap(:) );
    valueMapMin = min( valueMap(:) );
    if valueMapMax >= -valueMapMin
        valueMapMin = -valueMapMax;
    else
        valueMapMax = -valueMapMin;
    end
    figure
 %   subplot(1,2,2);
    valueMap_display = valueMap/(valueMapMax- valueMapMin)+ (-valueMapMin);
    %imagesc(imresize(valueMap_display,2));
    imagesc(imresize(valueMap,2));
    axis image; axis off; colormap jet
    hold on
%     for j=1:3%size( torqueMaxValueMap, 1 )
%          plot( torqueMaxValueMap(j,2), torqueMaxValueMap(j,1), 'wx', 'markersize', 11, 'linewidth', 3 );
%      end
    fix_pts = [];
    for j=1:num_min       %size( torqueMinValueMap, 1 )
        plot( torqueMinValueMap(j,2)*2, torqueMinValueMap(j,1)*2, 'kx', 'markersize', 11, 'linewidth', 3 );
        fix_pts = [fix_pts; torqueMinValueMap(j,1)*2 + (size(1)-1)*2, torqueMinValueMap(j,2)*2  + (size(3)-1)*2];
    end
    fixation_points(i) = {fix_pts};
  %  title( 'value map with extrema' );

    %stregthened edges
%     figure;
%     imagesc(  sum(edgeContMaximum,3), [0,max(max(sum(edgeContMaximum,3)))] );
%     axis image; axis off; colormap gray
%     title( 'strengthened edges by positive torque' );
% 
%     figure;
%     imagesc( -sum(edgeContMinimum,3), [0,max(max(sum(-edgeContMinimum,3)))]  );
%     axis image; axis off; colormap gray
%     title( 'strengthened edges by negative torque' );
end;
