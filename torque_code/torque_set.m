function fixation_points = torque_set(num_points, directory, resize_factor, torque_sizes, canny_thresholds)

% returns the fixation points as an array  the form : row, col coordinates 
%  currently it returns 4 fixation points per image
% 
num_fix_points = num_points;
close all
%addpath MAX-MOMENTS-PATCHES
%imsdir =  append('../',directory);

imsdir = directory

disp(imsdir)
%imsdir =  'C:\Data\matlab\torque\codeTorque1\obj-test\';
Aims    = dir([imsdir '/*.jpg']);
fixation_points = zeros(length(Aims)*num_fix_points, 2);


disp(length(Aims))

for i = 1:length(Aims)

    imname = [imsdir, Aims(i).name];

    disp(imname)

    im1_double = imread(imname); 

    %figure;
    %imshow(im1_double)
    
    %figure;
    %imshow(im1_double)



    %im1 = im1_double
    im1 = imresize(im1_double,resize_factor);
    
    %figure;
    %imshow(im1)
    
    % use only the table
    % size =[ miny, maxy, minx, maxx];
  % size for 2-3 objects

    %size =[ 175 240 57 316];

    % size for image twice the size
    % size = [357 480 110 640]
    % size for many objects
    % size =[ 176, 240, 21, 320];
  
    im = im1;
    %im = im1(size(1):size(2), size(3):size(4), :);
    % edge detection

    %thresh = [.2,.4];    % adjust thresh
    thresh = cell2mat(canny_thresholds)
    edges = computeCannyEdge( im, thresh , resize_factor );

    % compute torque maps
    %patchList = (3:2:45)';
    %patchList = (3:4:29)';
    %patchList = (3:3:29)';

    patchList = cell2mat(torque_sizes);
    patchList = double(patchList(:));

    momentStack = computeTorque( edges, patchList );

    % compute scale map and value map
    [scaleMap, valueMap, momentStackMin, momentStackMax] = findMaxMinTorqueScale( momentStack, patchList );

    % find extrema in torque volume
    [torqueMax, torqueMin] = computeTorqueExtrema( momentStack, patchList );

    % find extrema in value map
    [torqueMaxValueMap, torqueMinValueMap] = computeTorqueExtremaValueMap( valueMap, momentStack, patchList);
    %[torqueMaxValueMap, torqueMinValueMap] = computeTorqueExtremaValueMap( valueMap, momentStack, patchList );

    % stregthened edges
    edgeContMaximum = computeEdgeContribution( edges, [torqueMax(:,2),torqueMax(:,1)], torqueMax(:,3) );
    edgeContMinimum = computeEdgeContribution( edges, [torqueMin(:,2),torqueMin(:,1)], torqueMin(:,3) );

    %
    % display
    %

    % image
    
    %figure;
    %subplot(1,2,1);
    %imshow( imresize(im,(1/resize_factor)) );
 %   title( 'test image' );
  

    % value map with extrema
    valueMapMax = max( valueMap(:) )
    valueMapMin = min( valueMap(:) )
    if valueMapMax >= -valueMapMin
        valueMapMin = -valueMapMax;
    else
        valueMapMax = -valueMapMin;
    end

    figure(2);
    %subplot(1,2,2);
    valueMap_display = valueMap/(valueMapMax- valueMapMin)+ (-valueMapMin);
    imagesc(imresize(valueMap,(1/resize_factor)));
    axis image; axis off; colormap jet
    %hold on

    figure(3);
    imshow(imresize(im,(1/resize_factor)))
    %hold on

%     for j=1:3%size( torqueMaxValueMap, 1 )
%          plot( torqueMaxValueMap(j,2), torqueMaxValueMap(j,1), 'wx', 'markersize', 11, 'linewidth', 3 );
%      end
    for j=1:num_fix_points  %size( torqueMinValueMap, 1 )

        figure(2);
        hold on;
        plot( torqueMinValueMap(j,2)*(1/resize_factor), torqueMinValueMap(j,1)*(1/resize_factor), 'kx', 'markersize', 11, 'linewidth', 3 );
        plot( torqueMaxValueMap(j,2)*(1/resize_factor), torqueMaxValueMap(j,1)*(1/resize_factor), 'w*', 'markersize', 11, 'linewidth', 3 );
        hold off;

        figure(3);
        hold on;
        plot( torqueMinValueMap(j,2)*(1/resize_factor), torqueMinValueMap(j,1)*(1/resize_factor), 'kx', 'markersize', 11, 'linewidth', 3 );
        plot( torqueMaxValueMap(j,2)*(1/resize_factor), torqueMaxValueMap(j,1)*(1/resize_factor), 'w*', 'markersize', 11, 'linewidth', 3 );
        hold off;

        fixation_points((i-1)*num_fix_points + j, 2) = torqueMinValueMap(j,2)*(1/resize_factor);
        fixation_points((i-1)*num_fix_points + j, 1) = torqueMinValueMap(j,1)*(1/resize_factor);
    end
   title( 'value map with extrema: black x is negative, white * is positive' );

    %stregthened edges
    %figure;
    %imagesc(  sum(edgeContMaximum,3), [0,max(max(sum(edgeContMaximum,3)))] );
    %axis image; axis off; colormap gray
 %   title( 'strengthened edges by positive torque' );

    %figure;
    %imagesc( -sum(edgeContMinimum,3), [0,max(max(sum(-edgeContMinimum,3)))]  );
    %axis image; axis off; colormap gray
 %   title( 'strengthened edges by negative torque' );
 
end;

uiwait(helpdlg('Examine the figures, then click OK to finish.'));

