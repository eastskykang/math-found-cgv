%% EXERCISE X - PART X
clc 
close all 
clear all 

% paths
addpath(genpath('Part 2 - Interactive Segmentation'))
addpath(genpath('functions'))

% parameters

% debug
debug = true;

%% MAIN 
disp('===================================================================')
disp('data loading...')

disp('-------------------------------------------------------------------')

if debug 
    
    % figure idx
    fig_idx = 1;
    
    % options & params
    max_iter = 100;
    color_hist_implemented = false;
        
    % get image (batman)
    I = imread('Part 2 - Interactive Segmentation/batman.jpg');
    
    % size of the image
    [h, w, ~] = size(I);
    
    % load scribbles
    load('Part 2 - Interactive Segmentation/scribbles2.mat');
    
    % show image with scribbles
    figure(fig_idx)
    imshow(I)
    hold on
    plot(seed_fg(:, 1), seed_fg(:, 2), '.r') % foreground
    plot(seed_bg(:, 1), seed_bg(:, 2), '.b') % background
    hold off
    fig_idx = fig_idx + 1;
    
    % get color hist
    if ~color_hist_implemented
        % load color hist 
        disp('load histogram from file...')
        load('Part 2 - Interactive Segmentation/colorHist.mat');
    else
        % get color hist from my function (getColorHistogram)
        
        % TODO check if two color histograms are same
        disp('calculate color histogram')
        hist_fg = getColorHistogram(I, seed_fg, 32);
        hist_bg = getColorHistogram(I, seed_bg, 32);
    end
    
    f_i = fi(hist_fg, hist_bg, I);
    
    % primal dual algorithm 
    % initialization
    sigma = 0.35;
    tau = 0.35;
    lambda = 0.0075;
    theta = 1;
    
    % (x_0, y_0) in X x Y
    x = double(I);
    y = div(x, [h, w]);
    
    % x_bar_0 = x_0
    x_bar = x;
    
    % iteration 
    for i=1:max_iter 
        % TODO: termination condition
        % TODO: shape check
        
        % y_n+1
        grad_xn_bar = grad(x_bar, [h, w]);  % grad(x_bar_n)
        
        y = (y + sigma * grad_xn_bar) ...
            ./ max(1, norm2(y + sigma * grad_xn_bar));
        
        % x_n+1
        div_y = div(y, [h, w]); % div(y_n+1)
        x_n = x;                % x before update (save temporary for x_bar)
        
        f = fi(hist_fg, hist_bf, I);
        x = min(1, max(0, x - tau * (- div_y) + tau * f));
        
        % x_bar_n+1
        x_bar = x + theta * (x - x_n);
    end
    
    % result of iteration 
    x = reshape(x, [h, w]);
    
    figure(fig_idx)
    imshow(uint8(x))
    fig_idx = fig_idx + 1;

end

function [f_i] = fi(hist_fg, hist_bg, I)
    
    % rgb channels
    I_r = I(:, :, 1);
    I_g = I(:, :, 2);
    I_b = I(:, :, 3);

    % resolution 
    histRes = size(hist_fg, 1);
    
    % calculate f_i
    r_bin = idivide(I_r(:), (256 / histRes)) + 1;
    g_bin = idivide(I_g(:), (256 / histRes)) + 1;
    b_bin = idivide(I_b(:), (256 / histRes)) + 1;
    
    % change sub to ind
    idx = sub2ind(size(hist_fg), r_bin, g_bin, b_bin);
    
    f_i = log (hist_bg(idx)) - log (hist_fg(idx));
end

function [grad_x, grad_y] = grad(f, size)
    
    % input f is vectorized
    f = reshape(f, size);
    
    % Neumann boundary condition 
    f = padarray(f, [1, 1], 'replicate', 'post');
    
    % get forward differences
    grad_x = diff(f, 1, 2);
    grad_y = diff(f, 1, 1);
    
    if size(f) ~= size
        error('grad error: size does not match')
    end
end

function [div_f] = div(f, size)
    
    % input f is vectorized
    f = reshape(f, size);
    
    % Neumann boundary condition 
    f = padarray(f, [1, 1], 'replicate', 'pre');
    
    % get backward difference 
    div_f = diff(f, 1, 2) + diff(f, 1, 1); 
       
    if size(f) ~= size
        error('grad error: size does not match')
    end
end