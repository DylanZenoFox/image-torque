 This code implements a scale invariant patch detector in which the selected 
 patches are those with maximum moments with respect to their centers. The 
 "forces" from which the moments are calculated are unit vectors along the 
 edges detected in the image, with one unit vector per edge pixel in the 
 direction of the edge. The direction is oriented so that the bright side of
 the edge is to the right. 

 The goal of the method is to select patches that contain mostly closed contours. 
 The hope is that these regions with mostly closed contours tend to correspond to
 parts of objects. At every given image point p = (x, y) we look at moments for 
 the patches at neighbor pixels and neighbor patch scales (see function find3DMax)
 and pick up patches with maximum moments.
 
 The moments in patches aat different scales and locations are computed from 
 INTEGRAL MOMENT IMAGES with respect to the upper left corner of the image.

Tree of function calls:

testAll.m % This is the main function, takes an image as argument
o imread % read image

o amitEdgeFinder % implements Yali Amit's edge detector.
oo findGradient % Find if there is a gradient in direction shiftDir (one of 4) at each pixel
ooo myShift % shifts image by translation shiftVector

o edgeLabel % draw edges with colors corresponding to orientations (8 colors)
o findWeights % pixels with 2 edge orientations have weight 1/2, etc
o integralStackImage % computes integral stack of a 3D stack
o makeMomentArms % computes 8 moment arms of each pixel wrt top left image pt
o makePatchList % list of scales we consider when finding scale space max

o findMomentScaleStack % Find 3D stack of moments over different patch sizes 
oo findAllPatchHistos % Use integral moment images to find patch moments
ooo my3DShift % Shift stack in 3D (x, y, scale)

o find3DMax % Find locations of maxima both in x, y, scale
oo my3DShift % Shift stack in 3D (x, y, scale)

o sortPatches % sort bright patches with highest moments, same with dark patches; change nb of patches, now 500

o overlayColorPatches % draw 500 max patches 
oo drawMyRect