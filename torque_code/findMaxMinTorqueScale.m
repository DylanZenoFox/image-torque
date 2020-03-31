function [scaleMap,scaleValue,scaleStackMin,scaleStackMax] = findMaxMinTorqueScale( scaleStack, patchList )
%
    scaleStackMax = max( scaleStack, [], 3 );
    scaleStackMin = min( scaleStack, [], 3 );
    
    height = size(scaleStack,1);
    width  = size(scaleStack,2);
    scales = size(scaleStack,3);

    if exist( 'patchList', 'var' ) ~= 1 || isempty( patchList )
        patchList = 1:scales;
    end
    
    flgMax = scaleStack==repmat( scaleStackMax,[1,1,scales] );
    flgMin = scaleStack==repmat( scaleStackMin,[1,1,scales] );

    
    scaleIndex = repmat( reshape( patchList, [1,1,scales] ), [height,width,1] );
    
    scaleMapMax = max( flgMax.*scaleIndex, [], 3 );
    scaleMapMin = max( flgMin.*scaleIndex, [], 3 );

    msk = scaleStackMax>=-scaleStackMin;

    scaleValue = scaleStackMin;
    scaleValue(msk) = scaleStackMax(msk);

    scaleMap = -scaleMapMin;
    scaleMap(msk) = scaleMapMax(msk);
    
    mskNaN = prod(double(flgMax),3)==1 | prod(double(flgMin),3)==1;
    
    scaleMap( mskNaN ) = NaN;

    mskNaN = ( scaleStackMax ~= 0 ) & ( scaleStackMax == -scaleStackMin );
    scaleValue( mskNaN ) = NaN;
