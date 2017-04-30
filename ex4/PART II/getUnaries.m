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

    disp('-------------------------------------------------------------------')
    disp('get unary cost from histogram...')
    tic

    % data
    N = size(I(:,:,1), 1) * size(I(:,:,1), 2);
    unaries = zeros(N, 2);
    
    I_r = I(:,:,1);
    I_g = I(:,:,2);
    I_b = I(:,:,3);
    
    % positions of fg seed
    x_fg = seed_fg(:, 1);
    y_fg = seed_fg(:, 2);
    
    % positions of bg seed
    x_bg = seed_bg(:, 1);
    y_bg = seed_bg(:, 2);
    
    % index of seeds
    idx_fg = sub2ind(size(I(:,:,1)), y_fg, x_fg);
    idx_bg = sub2ind(size(I(:,:,1)), y_bg, x_bg);
    
    % index of non-seeds data points
    idx_seed = union(idx_fg, idx_bg);
    idx_other = setdiff(1:N, idx_seed);
    
    % object seed points
    for i=1:size(idx_fg, 1)
        idx = idx_fg(i);
        
        unaries(idx, 1) = inf;
        unaries(idx, 2) = 0;
    end
    
    % background seed points
    for i=1:size(idx_bg, 1)
        idx = idx_bg(i);
        
        unaries(idx, 1) = 0;
        unaries(idx, 2) = inf;
    end
    
    % other points
    for i=1:size(idx_other, 2)
        idx = idx_other(i);
        
        r = I_r(idx);
        g = I_g(idx);
        b = I_b(idx);
        
        rgb = cat(3, r, g, b);
        
        unaries(idx, 1) = lambda * Rp(hist_bg, rgb);
        unaries(idx, 2) = lambda * Rp(hist_fg, rgb);
    end

    toc;
end

function Rp = Rp(hist, rgb)
    histRes = size(hist, 2);
    
    r_bin = idivide(rgb(1), (256 / histRes)) + 1;
    g_bin = idivide(rgb(2), (256 / histRes)) + 1;
    b_bin = idivide(rgb(3), (256 / histRes)) + 1;
    
    Rp = -log(...
        hist(1, r_bin, 1) * ...
        hist(1, g_bin, 2) * ...
        hist(1, b_bin, 3) + 1e-10);
end