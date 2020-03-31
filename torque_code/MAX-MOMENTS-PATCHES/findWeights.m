function weights = findWeights(edges)
%
% Find weights for each pixels, giving lower weights to pixels having several edges

edgeCount = sum(double(edges), 3); % sum along third dimension
zeroWeights = (edgeCount==0); % where weight should be zero
edgeCount(zeroWeights) = 1; % set zeros to 1 to avoid division by zero
weights = ones(size(edgeCount));
weights = weights ./ edgeCount; 
weights(zeroWeights) = 0; % set weights to zero where there is no edges
