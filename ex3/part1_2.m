%% EXERCISE 3 - PART 1-2
clc
% close all
clear all

% paths
addpath(genpath('files/TASK1'))
addpath('functions')
addpath('data')

% parameters
x_min = -2;     % x_min <= -2
x_max = 2;      % x_max >= 2
y_min = -2;     % y_min <= -1
y_max = 2;      % y_max >= 1

delta_x = 0.01;
delta_y = 0.01;

datasets = [1, 2, 3];
sigmas = [1, 0.1, 0.01, 0.001];
threshold = 1e-5;   % threshold for curve fitting

% visualization
compare_dataset = true;
compare_sigma_data = true;

datacurve_YN = true;
normalvector_YN = true;
fittedcurve_YN = true;

% debug
debug = false;
saved_data = false;

if saved_data
    error('saved data is only for debugging. make it false')
end

%% PART 1-2
disp('===================================================================')
disp('PART 1-2')

% domain range
x_range = x_min:delta_x:x_max;
y_range = y_min:delta_y:y_max;

if ~saved_data
    % initialize F_array
    F_array = zeros(size(y_range, 2), size(x_range, 2), size(datasets, 2), size(sigmas, 2));
else
    % load from file (for debug)
    load('data/F_array.mat')
end

for data_idx = 1:size(datasets, 2)
    %% DATA LOAD
    dataset = datasets(data_idx);
    
    disp('-------------------------------------------------------------------')
    disp(['data loading: curve_data', num2str(dataset)])
    
    % nix, niy, xi, yi
    load(['curve_data', num2str(dataset), '.mat']);
    
    %% C0 MATRIX
    if ~saved_data
        disp('calculate C0 matrix')
        
        for i=1:size(sigmas, 2)
            sigma = sigmas(i);
            disp(['for sigma = ', num2str(sigma)])
            
            % calculate F(x) = C0(x) array
            F_array(:,:,data_idx,i) = Fx2D(xi, yi, nix, niy, x_range, y_range, sigma, debug);    
        end
    end
    
    %% VISUALIZATION
    % figure 4: comparing dataset
    if compare_dataset
        disp('plot dataset')
        
        figure(size(datasets, 2) + 1)
        subplot(1, 3, data_idx)
        
        % curve
        plot(xi, yi, 'r-')
        title(['curve data', num2str(data_idx)])
        xlabel('x')
        ylabel('y')
        
        % normal vectors
        hold on
        quiver(xi, yi, nix, niy)
        hold off
        axis equal
        xlim([x_min, x_max])
        ylim([y_min, y_max])
    end
    
    % figure 1, 2, 3: comparing sigma
    if compare_sigma_data
        disp('plot implicit mls surface')
        
        figure(data_idx)
        for i=1:size(sigmas, 2)
            sigma = sigmas(i);

            subplot(2, 2, i)
            VisCompSigma(x_range, y_range, F_array(:,:,data_idx,i), ...
                sigma, xi, yi, nix, niy, threshold, ...
                datacurve_YN, normalvector_YN, fittedcurve_YN);
        end
    end
end