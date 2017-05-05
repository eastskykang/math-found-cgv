%% EXERCISE 4 - PART 2-2
clc
close all
clear

% paths
addpath(genpath('PART II'))

% debug
debug = true;

%% MAIN

if debug
    % this is for debugging
    
    % with VanDamme
    disp('-------------------------------------------------------------------')
    disp('debug with a given image')
    
    %% LOAD
    lambda = 1;
    
    image = imread('PART II/Images/VanDamme.jpg');
    load('PART II/scribbles/scribbles_JCVD.mat');

%     image = imread('PART II/Images/batman.jpg');
%     load('PART II/scribbles/scribbles_batman.mat');

%     image = imread('img/upton_resized.jpg');
%     load('img/scribbles_upton.mat');

    figure(1)
    imshow(image)
    hold on
    plot(seed_fg(:, 1), seed_fg(:, 2), '.r') % foreground
    plot(seed_bg(:, 1), seed_bg(:, 2), '.b') % background
    hold off
    
    %% HISTOGRAM
    disp('histogram of seeds...')
    
    tic
    hist_fg = getColorHistogram(image, seed_fg, 32);
    hist_bg = getColorHistogram(image, seed_bg, 32);
    toc;
    
    figure(2)
    hist_fg_v = double(squeeze(hist_fg));
    hist_fg_v(hist_fg_v==0)=nan;
    h1 = slice(hist_fg_v, [], [], 1:size(hist_fg_v,3));
    set(h1, 'EdgeColor','none', 'FaceColor','interp')
    alpha(0.1)
    
    figure(3)
    hist_bg_v = double(squeeze(hist_bg));
    hist_bg_v(hist_bg_v==0)=nan;
    h2 = slice(hist_bg_v, [], [], 1:size(hist_bg_v,3));
    set(h2, 'EdgeColor','none', 'FaceColor','interp')
    alpha(0.1)
    
    %% UNARY COST    
    unaries = getUnaries(image, lambda, hist_fg, hist_bg, seed_fg, seed_bg);
    
    unary_s = reshape(unaries(:,1), size(image, 1), size(image, 2));
    unary_t = reshape(unaries(:,2), size(image, 1), size(image, 2));
    
    figure(4)
    imshow(image)
    title('source unary cost (low value is obj)')
    colorbar
    hold on
    imagesc(unary_s);
    hold off
    
    figure(5)
    imshow(image)
    title('sink unary cost (low value is bkg)')
    colorbar
    hold on
    imagesc(unary_t);
    hold off
    
    %% PAIRWISE COST
    tic
    pairwise = getPairWise(image); % complete getPairWise.m
    toc;
    
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
    BK_SetPairwise(graph, pairwise);
%     BK_SetNeighbors(graph, pairwise);
    
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
    
    % labels: 1 for obj, 2 for bkg
    mask_fg = (results == 1);
    mask_bg = (results == 2);
    
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
%     I_bck  = imread('img/cab_resized.png');
    
    % crop background
    I_bck = I_bck(1:height, 1:width, :);
    I_orig(mask_bg(:,:,[1,1,1])) = I_bck(mask_bg(:,:,[1,1,1]));
    
    figure(8)
    imshow(I_orig);
else
    % gui
    disp('===================================================================')
    disp('PART 2-2')
    
    interactiveGraphCut;
end