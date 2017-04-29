%% EXERCISE 4 - PART 1-2
clc
close all
clear all

% paths
addpath(genpath('PART I'))
addpath('functions')

% parameters
array_size = 100;

% parameters (do not change)
d = 2;
d_Vd = 2 * pi();
V = 1;

sigma = 0.25;
ra = 0.01 * sigma;
rb = 5;

% data (do not change)
algo = {'Matern', 'FPO', 'Dart', 'Balzer'};
file_no = 10;

% debug
debug = false;

%% TASK2
disp('===================================================================')
disp('PART 1-2')

pcf_array = zeros(array_size, 1);

% generate r values for the range [ra, rb]
r_array = ra:(rb-ra)/(array_size-1):rb;   

for a_idx = 1:size(algo, 2)
    for f_idx = 1:1        
        % data load
        disp('-------------------------------------------------------------------')
        disp(['load data - algorithm : ', algo{a_idx}, num2str(f_idx)])

        X = load(['PART I/Data/', algo{a_idx}, '/', num2str(f_idx) ,'.txt']);
        
        % number of points
        n = size(X, 1);
        
        % normalize points and V
        r_max = Rmax(n, 'Gamito-Maddock');
        X_normalized = X / r_max;
        V_normalized = V / r_max^2;
        
        % pairwise distance 
        d_ij = pdist(X_normalized);
        d_ij = squareform(d_ij);    % change to square form
        d_ij = d_ij(d_ij~=0);
        
        for r_idx = 1:array_size
            r = r_array(r_idx);
            
            % k_sigma(x) = 1 / (sqrt(pi()) * sigma) * exp(- x^2 / sigma^2)
            % k_sigma(r - d_ij)
            k_sigma = 1/ (sqrt(pi()) * sigma) * exp(- (r - d_ij).^2 / sigma^2);
            
            g_r = V_normalized / (d_Vd * r^(d-1) * n^2) * sum(k_sigma);
            pcf_array(r_idx) = g_r;
        end
        
        figure(a_idx)
        plot(r_array, pcf_array)
        
        disp(r_array)
    end
end