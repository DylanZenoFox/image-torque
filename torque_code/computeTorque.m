function [momentStack] = computeTorque( edges, patchList )
%
% computing torque for edge map
%

    szEdges = size(edges);
    
	weights = findWeights(edges);
    
    %figure; imshow(weights)
    
	replicatedWeights = repmat(weights, [1 1 8]);
	weightedEdges = edges .* replicatedWeights;

	sumEdges = integralStackImage(weightedEdges);

    momentArms = makeMomentArms(szEdges(1), szEdges(2));
	moments = momentArms .* weightedEdges;
	sumMoments = integralStackImage(moments);

	momentStack = findMomentScaleStack( momentArms, sumEdges, sumMoments, patchList );
    