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

% load('')


if debug 
    
    % params
    color_hist_implemented = false;
    
    lambda = 0.0075;
    
    % get image (batman)
    I = imread('Part 2 - Interactive Segmentation/batman.jpg');
    
    % size of the image
    [h, w, ~] = size(I);
    
    % load scribbles
    load('Part 2 - Interactive Segmentation/scribbles2.mat');
    
    % show image with scribbles
    figure(1)
    imshow(I)
    hold on
    plot(seed_fg(:, 1), seed_fg(:, 2), '.r') % foreground
    plot(seed_bg(:, 1), seed_bg(:, 2), '.b') % background
    hold off
    
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