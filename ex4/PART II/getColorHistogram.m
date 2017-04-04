function hist = getColorHistogram(I,seed, histRes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute a color histograms based on selected points from an image
% 
% INPUT
% - I       : color image
% - seed    : Nx2 matrix containing the the position of pixels which will be
%             uset to compute the color histogram
% - histRes : resolution of the histogram
% 
% OUTPUT
% - hist : color histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
