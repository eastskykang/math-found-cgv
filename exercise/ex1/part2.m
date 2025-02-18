clc
close all
clear all

% functions
addpath('functions')

% random seed initialization
rng('shuffle','twister');

% data parameters
N = 100;
r_array = [0, 10];  % outlier ratio: 0 / 10 (%)
tau = 0.1;

x_max = 10;
x_min = -10;
y_max = 10;
y_min = -10;

domain = [x_min, x_max, y_min, y_max];

% model parameters
a = 1;
b = 0;
noise_radius = 0.1;

% check model parameter
if a*x_max + b > y_max || a*x_min + b < y_min
    error('synthetic model parameter is not feasible. data is out of domain.');
end

% IRLS parameter
tol = 0.001;
max_iter = 10000;

%% DATA GENERATION, IRLS & L1, LP & L1, LP & Linf
data = zeros(N, 2, size(r_array, 2));

% results
x_IRLS = zeros(1, 2, size(r_array, 2));
x_LP_L1 = zeros(1, 2, size(r_array, 2));
x_LP_Linf = zeros(1, 2, size(r_array, 2));

for i=1:size(r_array, 2)
    %% DATA GENERATION
    % outlier_ratio
    r = r_array(i);
    n_inlier = int32(N * (1 - r/100));
    n_outlier = int32(N * r/100);
    
    disp('======================================')
    disp(['data generating for r = ', num2str(r)])
    
    % inlier_vector
    inlier_vectors = GenerateInlierData('line', N, r, tau, domain, [a, b], noise_radius);
    
    % outlier_vector
    outlier_vectors = GenerateOutlierData('line', N, r, tau, domain, [a, b]);
    
    disp('data verifying... ')
    
    % data verification
    n_inlier_verified = nnz(VerifyInlier('line', [a, b], tau, inlier_vectors));
    n_outlier_verified = nnz(~VerifyInlier('line', [a, b], tau, outlier_vectors));
    
    % assert error if number of inliers/outliers are different with setup
    assert(n_inlier_verified == n_inlier);
    assert(n_outlier_verified == n_outlier);
    assert(n_inlier_verified + n_outlier_verified == N);
    
    disp(['data verified! (# of inlier = ', num2str(n_inlier), ', # of outlier = ', num2str(n_outlier), ')'])
    disp(' ')
    
    % generated data
    data(:,:,i) = [inlier_vectors; outlier_vectors];
    
    %% IRLS & L1
    disp('IRSL with L1 norm')
    
    tic;
    [x_IRLS(:,:,i), num_iter_IRLS, res] = IRLSWithL1Norm(data(:,:,i), tol, max_iter);
    t = toc;
    
    disp('Result = ')
    disp(x_IRLS(:,:,i))
    disp(['(# of iter = ', num2str(num_iter_IRLS), ')']);
    disp(['residual = ', num2str(res)])
    disp(['time = ', num2str(t)]);
    disp(' ')
    
    %% LP & L1
    disp('Linear Programming with L1 norm')
    
    tic;
    [x_LP_L1(:,:,i), res] = LinProgWithLqNorm('L1', data(:,:,i));
    t = toc;
    
    disp('Result = ')
    disp(x_LP_L1(:,:,i))
    disp(['residual = ', num2str(res)])
    disp(['time = ', num2str(t)]);
    disp(' ')

    
    %% LP & Linf
    disp('Linear Programming with Linf norm')
    
    tic;
    [x_LP_Linf(:,:,i), res] = LinProgWithLqNorm('Linf', data(:,:,i));
    t = toc;
    
    disp('Result = ')
    disp(x_LP_Linf(:,:,i))
    disp(['residual = ', num2str(res)])
    disp(['time = ', num2str(t)])
    disp(' ')
    
end

%% PLOTS
disp('======================================')
disp('plot...')

% var x for plot
x_syn = x_min:0.01:x_max;

figure(3) 
for i=1:size(r_array, 2)    

    % subplot1/4 (IRLS with L1 norm)
    subplot(2, 3, 3*(i-1) + 1)
    % data
    plot(data(:, 1, i), data(:, 2, i), 'bo')
    title('IRLS with L1 norm')
    hold on
    % IRLS
    plot(x_syn, x_IRLS(1, 1, i) * x_syn + x_IRLS(1, 2, i), 'k-')
    % synthetic model
    plot(x_syn, a * x_syn + b, 'g-')
    hold off
    axis(domain)
    legend('data', 'IRLS model', 'synth. model', 'location', 'northwest')
    
    % subplot2/5 (LP with L1 norm)
    subplot(2, 3, 3*(i-1) + 2)
    % data
    plot(data(:, 1, i), data(:, 2, i), 'bo')
    title('Linear Programming with L1 norm')
    hold on
    % LP & L1
    plot(x_syn, x_LP_L1(1, 1, i) * x_syn + x_LP_L1(1, 2, i), 'k-')
    % synthetic model
    plot(x_syn, a * x_syn + b, 'g-')
    hold off
    axis(domain)
    legend('data', 'IRLS model', 'synth. model', 'location', 'northwest')

    % subplot3/6 (LP with Linf norm)
    subplot(2, 3, 3*(i-1) + 3)
    % data
    plot(data(:, 1, i), data(:, 2, i), 'bo')
    title('Linear Programming with Linf norm')
    hold on
    % LP & Linf
    plot(x_syn, x_LP_Linf(1, 1, i) * x_syn + x_LP_Linf(1, 2, i), 'k-')
    % synthetic model
    plot(x_syn, a * x_syn + b, 'g-')
    hold off
    axis(domain)
    legend('data', 'IRLS model', 'synth. model', 'location', 'northwest')

end

