clc
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

% features 
gf_on = true;
hd_on = true;
va_on = true;

save_jpg = true;
results_dir = './results';

% gaussian filtering
gf_sigma = 0.5;
gf_iter = [8, 16, 24, 32];

% heat diffusion
hd_step = 0.1;
hd_iter = [25, 50, 75, 100];

% variational method
lambda = 2;

% image export noisy img
if save_jpg
    
    % check if results dir exsits
    if exist(results_dir, 'dir') ~= 7
        error(['results directory does not exists. ', ... 
            'make variable save_png false ', ...
            'or create directory with path = ', ...
            results_dir ])
    end
    
    % export
    imwrite(uint8(In), fullfile(results_dir, 'noisy_image.jpg'))
end

%% TASK1: FILTERING
if gf_on
    % image
    I_gf = double(In);
    
    % size
    gf_radius = ceil(3 * gf_sigma);
    gf_size = 2 * gf_radius + 1;
    
    % kernel
    H_gf = GaussianKernel(gf_size, gf_sigma);
    
    % error evolution
    errors_gf = zeros(gf_iter(end), 1);
    
    % figure
    figure(2)
    subplot_idx = 1;
    
    for i=1:gf_iter(end)
        % padding
        I_gf = ImagePadding(I_gf, [gf_radius, gf_radius]);
        
        % convolution
        I_gf = conv2(I_gf, H_gf, 'valid');
        
        if gf_iter(subplot_idx) == i
            % subplot
            subplot(2, 2, subplot_idx)
            imshow(uint8(I_gf))
            title(['Filtered ', num2str(i), ' times'])
            
            subplot_idx = subplot_idx + 1;
            
            % image export
            if save_jpg
                imwrite(uint8(I_gf), fullfile(results_dir, ['gf_', num2str(i), '.jpg']))
            end
        end
        
        % error
        error = Error(double(Iorig), I_gf);
        errors_gf(i) = error;
    end
    
    % error figure
    figure(3)
    plot(errors_gf)
    title('Evolution of the errors over the number of filtering')
    ylabel('Mean squared error')
    xlabel('Number of filtering')
end

%% TASK2: HEAT DIFFUSION
if hd_on
    I_hd = double(In);
    
    % kernel
    H_hd = LaplaceKernel;
    
    % size
    hd_radius = floor(size(H_hd, 1) / 2);
    
    % error evolution
    errors_hd = zeros(hd_iter(end), 1);
    
    % figure
    figure(4)
    subplot_idx = 1;
    
    for i=1:hd_iter(end)
        % padding
        I_hd_pad = ImagePadding(I_hd, [hd_radius, hd_radius]);
        
        % convolution
        I_hd = I_hd + conv2(I_hd_pad, H_hd, 'valid') * hd_step;
        
        if hd_iter(subplot_idx) == i
            % subplot
            subplot(2, 2, subplot_idx)
            imshow(uint8(I_hd))
            title(['Diffusion at time ', num2str(i)])
            
            subplot_idx = subplot_idx + 1;
            
            % image export
            if save_jpg
                imwrite(uint8(I_hd), fullfile(results_dir, ['hd_', num2str(i), '.jpg']))
            end
        end
        
        % error
        error = Error(double(Iorig), I_hd);
        errors_hd(i) = error;
    end
    
    % error figure
    figure(5)
    plot(errors_hd)
    title('Evolution of the errors over the iterations')
    ylabel('Mean squared error')
    xlabel('Iteration')
end

%% TASK3: VARIATIONAL METHOD
if va_on
    I_va = double(In);
    
    % pixel size of image
    n = h * w;
    
    % A matrix
    A = sparse(n, n);
    
    % main diagonal term 
    A = A + sparse(1:n, 1:n, 1 + 4 * lambda, n, n);
    
    % k=1 diagonal term 
    A = A + sparse(1:(n-1), 2:n, -lambda, n, n);
  
    % k=-1 diagonal term
    A = A + sparse(2:n, 1:(n-1), -lambda, n, n);
    
    % k=h diagonal term
    A = A + sparse(1:(n-h), (h+1):n, -lambda, n, n);
    
    % k=-h diagonal term
    A = A + sparse((h+1):n, 1:(n-h), -lambda, n, n);
    
    % linear operation (inv(A) * I0 = I)
    I_va = A\(I_va(:));
    I_va = reshape(I_va, h, w);
    
    % figure
    figure(6)
    subplot(1, 2, 1)
    imshow(In)
    title('Noisy image')
    
    subplot(1, 2, 2)
    imshow(uint8(I_va))
    title('Variational denoising')
    
    % image export
    if save_jpg
        imwrite(uint8(I_va), fullfile(results_dir, 'va.jpg'))
    end
end

%% FUNCTIONS
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

function [error] = Error(I_orig, I)
    % mean squared error
    error = mean((I_orig(:) - I(:)) .^ 2);
end