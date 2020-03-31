function sumEdgeContribution = computeEdgeContribution( edges, pt, patchSize )
%
% computing contributions for every edge pixels to a 
% torque at a given point and patch size.
%


    szEdges = size(edges);

	weights = findWeights(edges);
	replicatedWeights = repmat(weights, [1 1 8]);
	weightedEdges = edges .* replicatedWeights;

    momentArms = makeMomentArms(szEdges(1), szEdges(2));

    sumEdgeContribution = zeros( szEdges );
    
    for i=1:size(pt,1)
        width = patchSize(i);
        
        halfSize = floor(0.5 * width);

        normalizer = 2 * width * width;

        momentArmsFromCenter = momentArms - repmat(momentArms(pt(i,2),pt(i,1),:), szEdges(1:2));
        edgeContribution = momentArmsFromCenter .* weightedEdges;

        edgeContribution = edgeContribution/normalizer;

        edgeContribution(1:max(1,pt(i,2)-halfSize-1),:,:) = 0;
        edgeContribution(:,1:max(1,pt(i,1)-halfSize-1),:) = 0;
        edgeContribution(min(pt(i,2)+halfSize+1,szEdges(1)):end,:,:) = 0;
        edgeContribution(:,min(pt(i,1)+halfSize+1,szEdges(2)):end,:) = 0;

        sumEdgeContribution = sumEdgeContribution + edgeContribution;
    end
    