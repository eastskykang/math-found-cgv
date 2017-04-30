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
    
    figure(1)
    imshow(image)
    hold on
    plot(seed_fg(:, 1), seed_fg(:, 2), 'r') % foreground
    plot(seed_bg(:, 1), seed_bg(:, 2), 'b') % background
    hold off
    
    %% HISTOGRAM
    disp('histogram of seeds...')
    
    tic
    hist_fg = getColorHistogram(image, seed_fg, 32);
    hist_bg = getColorHistogram(image, seed_bg, 32);
    toc;
    
    figure(2)
    plot(hist_fg(:,:,1),'r')
    hold on
    plot(hist_fg(:,:,2),'g')
    plot(hist_fg(:,:,3),'b')
    title('foreground color hist')
    hold off
    
    figure(3)
    plot(hist_bg(:,:,1),'r')
    hold on
    plot(hist_bg(:,:,2),'g')
    plot(hist_bg(:,:,3),'b')
    title('background color hist')
    hold off
    
    %% UNARY COST
    unaries = getUnaries(image, 1.0, hist_fg, hist_bg, seed_fg, seed_bg);
    
    unary_s = reshape(unaries(:,1), size(image, 1), size(image, 2));
    unary_t = reshape(unaries(:,2), size(image, 1), size(image, 2));
    
    figure(4)
    imshow(image)
    colorbar
    hold on
    imagesc(unary_s);
    hold off
    
    figure(5)
    imshow(image)
    colorbar
    hold on
    imagesc(unary_t);
    hold off
    
    %% PAIRWISE COST
    pairwise = getPairWise(image); % complete getPairWise.m
    
    %% GRAPH CUT
    [height, width, ~] = size(image);
    n = height * width;
    
    % build graph
    disp('-------------------------------------------------------------------')
    disp(['creating graph with ', num2str(n), ' nodes'])
    
    graph = BK_Create(n);
    
    % unary cost
    disp('assign unary cost for source and sink... ')
    BK_SetUnary(graph, unaries');
    
    % pairwise cost
    disp('assign pairwise cost... ')
    BK_SetNeighbors(graph, pairwise);
    
    % optimal label 
    energy = BK_Minimize(graph);
    
    disp(['energy : ', num2str(energy)])
    labeling = BK_GetLabeling(graph);
        
    % dealloc
    disp('dealloc handle')
    
    BK_Delete(graph);
    
    %% RESULTS
    results = reshape(labeling, height, width);
    
    figure(6)
    imshow(image);
    hold on
    imagesc(results);
    hold off 
    
    % TODO check 
    mask_fg = (results == 2);
    mask_bg = (results == 1);
    
    I_r = image(:,:,1);
    I_g = image(:,:,2);
    I_b = image(:,:,3);
    
    % foreground to red
    I_g(mask_fg) = 0;
    I_b(mask_fg) = 0;
    
    % background to blue
    I_r(mask_bg) = 0;
    I_g(mask_bg) = 0;
    
    I = cat(3, I_r, I_g, I_b);
    
    figure(7)
    imshow(I);
    
    %% NEW BACKGROUND
    disp('-------------------------------------------------------------------')
    disp('change background image with ethz.png')
    
    I_orig = image;
    I_bck  = imread('PART II/Images/ethz.png');

    % crop background
    I_bck = I_bck(1:height, 1:width, :);
    I_orig(mask_bg(:,:,[1,1,1])) = I_bck(mask_bg(:,:,[1,1,1])); 

    figure(8)
    imshow(I_orig);
end