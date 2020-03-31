function [flgMinima, flgMaxima] = findExtrema( valueMap )
%
    w = 5;
    
    flgMaxima = true( size(valueMap) );
    flgMinima = true( size(valueMap) );
    for sc = -w:w
        for sr = -w:w
            if sr==0 && sc==0
                continue
            end
            valueMapShift = circshift( valueMap, [sr,sc] );
            flgMaxima = flgMaxima & (valueMap>valueMapShift);
            flgMinima = flgMinima & (valueMap<valueMapShift);
        end
    end
    