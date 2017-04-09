%% EXERCISE 4 - PART 1
clc
close all
clear all

% paths
addpath(genpath('PART I'))

% parameters
width = 400;
height = 400;

% data (do not change)
algo = {'Matern', 'FPO', 'Dart', 'Balzer'};
file_no = 10;

% debug
debug = false;

%% TASK1
disp('===================================================================')
disp('PART 1-1')

periodogram_array = zeros(height, width, file_no);

figure(1)

for a_idx = 1:size(algo, 2)
    for f_idx = 1:file_no
        img = zeros(height, width);
        
        % data load
        disp('-------------------------------------------------------------------')
        disp(['load data - algorithm : ', algo{a_idx}, num2str(f_idx)])

        X = load(['PART I/Data/', algo{a_idx}, '/', num2str(f_idx) ,'.txt']);
        
        n = size(X, 1);
        X = ceil(X .* [width, height]);
        
        % image matrix
        disp('building an image matrix ')

        for i=1:n
            X_i = X(i, :);
            
            if ~ (X_i(1) > 0 && X_i(2) > 0 && ...
                    X_i(1) <= width && X_i(2) <= height)
                % boundary check
                continue;
            end
            
            % (row = y, col = x)
            img(X_i(2), X_i(1)) = img(X_i(2), X_i(1)) + 1/n;
        end
        
        % fourier transfrom
        disp('building a periodogram matrix by fourier transform ')

        periodogram_array(:,:, f_idx) = abs(fftshift(fft2(img))) .^ 2;
    end
    
    % image show
    disp('-------------------------------------------------------------------')
    disp('plot average periodograms for algorithms ')

    subplot(2, 2, a_idx)
    imshow(mean(periodogram_array,3) * 200);
end