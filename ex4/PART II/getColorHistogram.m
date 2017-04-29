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

% positions of seed
x = seed(:, 1);
y = seed(:, 2);

% RGB
I_r = I(:,:,1);
I_g = I(:,:,2);
I_b = I(:,:,3);

% get values of intensities (0~255)
idx = sub2ind(size(I_r), y, x);

seed_r = I_r(idx);
seed_g = I_g(idx);
seed_b = I_b(idx);

% get histogram 
bin_edges = 0:histRes;
bin_edges = 256 / histRes .* bin_edges; 

hist_r = histcounts(seed_r, bin_edges);
hist_g = histcounts(seed_g, bin_edges);
hist_b = histcounts(seed_b, bin_edges);

hist = cat(3, hist_r, hist_g, hist_b);

% smooth with gaussian filter 
hist = smooth3(hist, 'gaussian', 7);

% normalize histogram
hist = hist ./ sum(hist, 2);

end