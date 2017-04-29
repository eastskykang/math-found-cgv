%% EXERCISE 4 - PART 2-2
clc
close all
clear all

% paths
addpath(genpath('PART II'))

% debug
debug = true;

%%

if debug
    % with VanDamme
    disp('-------------------------------------------------------------------')
    disp('debug with VanDamme.jpg')
    
    %% LOAD
    image = imread('PART II/Images/VanDamme.jpg');
    load('PART II/scribbles/scribbles_JCVD.mat');
    
    %% HISTOGRAM
    hist_fg = getColorHistogram(image, seed_fg, 32);    
    hist_bg = getColorHistogram(image, seed_bg, 32);
    
    figure(1)
    plot(hist_fg(:,:,1),'r')
    hold on
    plot(hist_fg(:,:,2),'g')
    plot(hist_fg(:,:,3),'b')
    title('foreground color hist')
    hold off
    
    figure(2)
    plot(hist_bg(:,:,1),'r')
    hold on
    plot(hist_bg(:,:,2),'g')
    plot(hist_bg(:,:,3),'b')
    title('background color hist')
    hold off
    
end
