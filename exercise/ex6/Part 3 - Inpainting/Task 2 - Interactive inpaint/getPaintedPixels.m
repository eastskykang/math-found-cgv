function paintedPixels = getPaintedPixels(centerPix, brushWidth, w, h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% When painting on an image of size h x w at a certain pixel position with 
% a brush of given size, the function returns the position of all pixels
% being painted.
% 
% INPUT : 
% - centerPix  : position of the pixel where the brush is applied
% - brushWidth : size of the brush
% - w          : image width
% - h          : image height
% 
% OUTPUT :
% - paintedPixels : Nx2 matrix containing the position of all pixels being
%                   painted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

centerPix_i = centerPix(2);
centerPix_j = centerPix(1);

[paintedPixels_j, paintedPixels_i] = meshgrid(-brushWidth:brushWidth, -brushWidth:brushWidth);

paintedPixels_j = centerPix_j + paintedPixels_j(:) ;
paintedPixels_i = centerPix_i + paintedPixels_i(:) ;

paintedPixels = [paintedPixels_j , paintedPixels_i];

% Remove pixels that are outside the boundaries of the image
removeOutOfBound = (paintedPixels_j < 1) + (paintedPixels_j > w) + ...
                   (paintedPixels_i < 1) + (paintedPixels_i > h);
paintedPixels(logical(removeOutOfBound),:) = [];

paintedPixels = floor(paintedPixels); % Make sure pixels are integer
