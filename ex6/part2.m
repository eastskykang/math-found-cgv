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
    
    % primal dual algorithm
    % initialization
    sigma = 0.35;
    tau = 0.35;
    lambda = 0.0075;
    theta = 1;
    
    % number of channels (rgb / grayscale)
    ch = size(I, 3);
    
    if ch ~= 3
        error('input should be rgb image')
    end
    
    % (x_0, y_0) in X x Y
    x = reshape(double(rgb2gray(I)), [], 1);
    y = grad(x, [h, w]);    
    y = y ./ max(y(:)); 
    
    % x_bar_0 = x_0
    x_bar = x;
    
    % precalculate f
    f = f_I(hist_fg, hist_bg, I);   % size: (w*h) x 1
    
    % iteration
    for i=1:max_iter
        % TODO: termination condition
        
        % y_n+1
        grad_xn_bar = grad(x_bar, [h, w]);  % grad(x_bar_n) / size: (w*h) x 2 x ch
        
        y = (y + sigma * grad_xn_bar) ...
            ./ max(1, sqrt(sum ((y + sigma * grad_xn_bar).^2, 2)));
        
        % x_n+1
        div_y = div(y, [h, w]);             % div(y_n+1) / size: (w*h) x 1 x ch
        x_n = x;                % x before update (save temporary for x_bar)
        
        x = min(1, max(0, x - tau * (- div_y) + tau * f));
        
        % x_bar_n+1
        x_bar = x + theta * (x - x_n);
    end
    
    % result of iteration (minimizer)
    x = reshape(x, h, w);
    
    figure(fig_idx)
    imshow(uint8(x))
    fig_idx = fig_idx + 1;
end