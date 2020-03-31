function edges = computeCannyEdge( im, thresh, sigma )
%
    if nargin < 2
        thresh = [];
    end
    
    if nargin < 3
        sigma = 1;
    end
        
    imGray = rgb2gray( im );
    imGray = double(imGray)/255;

    edgeS = edge( imGray,'canny', thresh, sigma );
    figure; imshow(imresize(edgeS,1.5));
    % compute edge direction
    sig = 0.5;
    delt = 1e-5;
    WH = sqrt(2*sig^2*(-log(sqrt(2*pi)*sig*delt)));
    H = fspecial('gaussian',2*ceil(WH)+1,sig);
    imGraySmoothed = imfilter( imGray, H );
    [gx,gy] = gradient( imGraySmoothed );
    theta = atan2( -gx, gy );
    theta( gx==0 & gy==0 ) = NaN;
    
    % split edges into eight directions
    theta = theta + pi/8.0;
    theta(theta<0) = theta(theta<0) + 2.0*pi;
    edges = zeros([size(edgeS),8]);
    for i=1:8
        mask = ( theta>=(i-1)/8.0*2.0*pi & theta<i/8.0*2.0*pi );
        edges(:,:,i) = edgeS .* mask;
    end
    