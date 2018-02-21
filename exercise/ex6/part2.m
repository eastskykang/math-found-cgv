%% EXERCISE 6 - PART 2
clc
close all
clear all

% paths
addpath(genpath('Part 2 - Interactive Segmentation'))
addpath(genpath('functions'))

% debug
debug = false;      % do not change

%% MAIN
disp('===================================================================')
disp('PART 2')

if debug

    % figure idx
    fig_idx = 1;
    
    % options & params
    max_iter = 2000;
    color_hist_implemented = true;
    
    % get image (batman)
    disp('-------------------------------------------------------------------')
    disp('load image...')
    I = imread('Part 2 - Interactive Segmentation/batman.jpg');
    
    % size of the image
    [h, w, ~] = size(I);
    
    % load scribbles
    disp('load scribbles...')
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
        disp('calculate color histogram')
        hist_fg = getColorHistogram(I, seed_fg, 32);
        hist_bg = getColorHistogram(I, seed_bg, 32);
    end
    
    % color histogram show 
    % foreground
    figure(fig_idx)
    hist_fg_v = double(squeeze(hist_fg));
    hist_fg_v(hist_fg_v==0)=nan;
    h1 = slice(hist_fg_v, [], [], 1:size(hist_fg_v,3));
    set(h1, 'EdgeColor','none', 'FaceColor','interp')
    title('Foreground Color Histogram')
    xlabel('Red')
    ylabel('Green')
    zlabel('Blue')
    alpha(0.4)    
    fig_idx = fig_idx + 1;
    
    % color histogram show 
    % background
    figure(fig_idx)
    hist_bg_v = double(squeeze(hist_bg));
    hist_bg_v(hist_bg_v==0)=nan;
    h2 = slice(hist_bg_v, [], [], 1:size(hist_bg_v,3));
    set(h2, 'EdgeColor','none', 'FaceColor','interp')
    title('Background Color Histogram')
    xlabel('Red')
    ylabel('Green')
    zlabel('Blue')
    alpha(0.4)
    fig_idx = fig_idx + 1;
    

    % primal dual algorithm
    disp('-------------------------------------------------------------------')
    disp('primal dual algorithm...')
    
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
%     x = reshape(double(rgb2gray(I)), [], 1);    % initialize with grayscale image
%     y = grad(x, [h, w]);        
%     y = y ./ max(y(:));                         % initialize with normalized gradient                
    
    x = zeros(h * w, 1);
    y = zeros(h * w, 2);
    
    % x_bar_0 = x_0
    x_bar = x;
    
    % precalculate f
    f = f_I(hist_fg, hist_bg, I);   % size: (w*h) x 1
    
    % iteration
    for i=1:max_iter
        
        % y_n+1
        grad_xn_bar = grad(x_bar, [h, w]);  % grad(x_bar_n) / size: (w*h) x 2 x ch
        
        y = (y + sigma * grad_xn_bar) ...
            ./ max(1, sqrt(sum ((y + sigma * grad_xn_bar).^2, 2)));
        
        % x_n+1
        div_y = div(y, [h, w]);             % div(y_n+1) / size: (w*h) x 1 x ch
        x_n = x;                % x before update (save temporary for x_bar)
        
        x = min(1, max(0, x - tau * (- div_y) + tau * lambda * f));
        
        % x_bar_n+1
        x_bar = x + theta * (x - x_n);
        
    end
    
    % result of iteration (minimizer)
    disp('-------------------------------------------------------------------')
    disp('show the result')
    
    x = reshape(x, h, w);
    
    figure(fig_idx)
    imshow(x)
    fig_idx = fig_idx + 1;
    
    figure(fig_idx)
    imshow(I)
    bw = (x > 0.99);
    B = bwboundaries(bw,'holes');
    hold on;
    for l=1:length(B)
        boundary = B{l};
        plot(boundary(:,2), boundary(:,1), 'y', 'linewidth', 2.0);
    end
    hold off;
    fig_idx = fig_idx + 1;
else
    % gui
    interactiveSeg;
end