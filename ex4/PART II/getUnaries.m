function unaries = getUnaries(I,lambda,hist_fg,hist_bg, seed_fg, seed_bg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Unaries for all pixels in inputImg, using the foreground and
% background color histograms, and enforcing hard constraints on pixels
% marked by the user as foreground and background
% 
% INPUT :
% - I       : color image
% - Lamda   : regularization parameter
% - hist_fg : foreground color histogram
% - hist_bg : background color histogram
% - seed_fg : pixels marked as foreground by the user
% - seed_bg : pixels marked as background by the user
% 
% OUTPUT :
% - unaries : Nx2 matrix containing the unary cost for every pixels in I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
