clear
close all

%% Set Parameters

Iorig = imread('lotr.jpg');
Iorig = rgb2gray(Iorig);

% Parameters of the image
[h,w] = size(Iorig);

% Noise
In = imnoise(Iorig,'gaussian',0,0.05);

% Show
figure(1)
clf
subplot(1,2,1)
imshow(Iorig);
title('Original image')
subplot(1,2,2)
imshow(In);
title('Noisy image')
box off

%% Your turn

% parameters
% gaussian filtering
gf_sigma = 0.5;
gf_iter = [8, 16, 24, 32];

% heat diffusion
hd_step = 0.1;
hd_iter = [25, 50, 75, 100];

%% TASK1: FILTERING
% image
I_gf = In;

% size
gf_radius = ceil(3 * gf_sigma);
gf_size = 2 * gf_radius + 1;

% kernel
H_gf = GaussianKernel(gf_size, gf_sigma);

subplot_idx = 1;

for i=1:gf_iter(end)    
    % padding
    I_gf = ImagePadding(I_gf, [gf_radius, gf_radius]);
    
    % convolution
    I_gf = uint8(conv2(I_gf, H_gf, 'valid'));
    
    if gf_iter(subplot_idx) == i
        % subplot 
        figure(1)
        subplot(2, 2, subplot_idx)
        imshow(I_gf)
        title(['Filtered', num2str(i), 'times'])
        
        subplot_idx = subplot_idx + 1;
    end
    
    % error 
    error = I_gf - In;
end

%% TASK2: HEAT DIFFUSION
I_hd = In;

% kernel
H_hd = LaplaceKernel;

% size
hd_radius = floor(size(H_hd, 1) / 2);

subplot_idx = 1;

for i=1:hd_iter(end)
    % padding
    I_hd_pad = ImagePadding(I_hd, [hd_radius, hd_radius]);
    
    % convolution 
    I_hd = I_hd + uint8(conv2(I_hd_pad, H_hd, 'valid')) * hd_step;
    
    if hd_iter(subplot_idx) == i
        % subplot 
        figure(2)
        subplot(2, 2, subplot_idx)
        imshow(I_hd)
        title(['Filtered', num2str(i), 'times'])
        
        subplot_idx = subplot_idx + 1;
    end
        
    % error 
    error = I_hd - In;
end

function [H] = GaussianKernel(gf_size, gf_sigma)
    H = fspecial('Gaussian', [gf_size, gf_size], gf_sigma);
end

function [H] = LaplaceKernel
    H = [0, 1, 0; 1, -4, 1; 0, 1, 0];
end

function [pad_img] = ImagePadding(img, padsize, type)
    
    if nargin == 2 
        % default is replicate
        pad_img = padarray(img, padsize, 'replicate');
    elseif nargin == 3
        % type option
        if strcmp(type, 'zero')
            pad_img = padarray(img, padsize);
        elseif strcmp(type, 'replicate')
            pad_img = padarray(img, padsize, 'replicate');
        else
            error('image padding error: type error')
        end
    else
        error('image padding error: the number of arguments')
    end
end