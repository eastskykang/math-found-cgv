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
hist = zeros(histRes, histRes, histRes);

for i = 1:size(idx)
    r_bin = idivide(seed_r(i), uint8(256 / histRes)) + 1;
    g_bin = idivide(seed_g(i), uint8(256 / histRes)) + 1;
    b_bin = idivide(seed_b(i), uint8(256 / histRes)) + 1;
    
    hist(r_bin, g_bin, b_bin) = hist(r_bin, g_bin, b_bin) + 1;
end
% smooth with gaussian filter 
hist = smooth3(hist, 'gaussian', 7);

% normalize histogram (divide by number of points)
hist = hist ./ sum(hist(:));

end