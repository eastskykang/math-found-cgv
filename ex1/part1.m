clc
clear all

% random seed initialization
rng('shuffle','twister');

% data parameters
N = 100;                    % number of data
r_array = [5, 20, 30, 70];  % outlier ratio: 5 / 20 / 30 / 70 (%)
tau = 0.1;  % inlier distance threshold

x_max = 10;
x_min = -10;
y_max = 10;
y_min = -10;

domain = [x_min, x_max, y_min, y_max];

% model parameters
x_c = 0;       % circle x center
y_c = 0;        % circle y center
radius = 5;    % circle radius
noise_radius = 0.1;

% ransac parameters
succ_rate = 99/100;     % (99 %)
n_sample_ransac = 3;
n_test_ransac = 1000;

% debug
debug = false;


%% GROUND TRUTH
% circular ground truth (synthetic model)
theta_truth = 0:0.1:pi()*2;
x_truth = radius * cos(theta_truth) + x_c;
y_truth = radius * sin(theta_truth) + y_c;

%% DATA GENERATION, RANSAC, EXHAUSTIVE SEARCH
data = zeros(N, 2, size(r_array, 2));

% results 
% row vector of best_result_ransac is [n_inlier, n_outlier, a, b, c]
result_ransac = zeros(n_test_ransac, 5, size(r_array, 2));
% row vector of best_result_exh_search is [n_inlier, n_outlier, a, b, c]
result_exh_search = zeros(size(r_array, 2), 5); % TODO

best_result_ransac = zeros(1, 5, size(r_array, 2));

for i=1:2%size(r_array, 2)
    %% DATA GENERATION
    % outlier_ratio
    r = r_array(i);
    n_inlier = int32(N * (1 - r/100));
    n_outlier = int32(N * r/100);
    
    disp(['data generating for r = ', num2str(r)])
    
    % ftn proto: GenerateInlierData( N, r, circle_param, noise_radius)
    inlier_vectors = GenerateInlierData(N, r, [x_c, y_c, radius], noise_radius);
    
    % ftn proto: GenerateOutlierData( N, r, tau, domain_param, circle_param )
    outlier_vectors = GenerateOutlierData( N, r, tau, domain, [x_c, y_c, radius] );
    
    disp('data verifying... ')
    
    % data verification
    n_inlier_verified = nnz(abs(pdist2(inlier_vectors, [x_c, y_c]) - radius) <= tau);
    n_outlier_verified = nnz(abs(pdist2(outlier_vectors, [x_c, y_c]) - radius) > tau);
    
    % assert error if number of inliers/outliers are different with setup
    assert(n_inlier_verified == n_inlier);
    assert(n_outlier_verified == n_outlier);
    assert(n_inlier_verified + n_outlier_verified == N);
    
    disp(['data verified! (# of inlier = ', num2str(n_inlier), ', # of outlier = ', num2str(n_outlier), ')'])
    disp(' ');
    
    % generated data
    data(:,:,i) = [inlier_vectors; outlier_vectors];   
    
    %% RANSAC    
    for j=1:n_test_ransac
        result_ransac(j,:,i) = RansacForCircularModel(data(:,:,i), succ_rate, r, tau, n_sample_ransac, debug);
        
        if result_ransac(j,1,i) > best_result_ransac(1,:,i)
            best_result_ransac(:,:,i) = result_ransac(j,:,i);
        end
    end
    
    %% EXHAUSTIVE SEARCH
%     result_exh_search(i,:) = ExhSearchForCircularModel(data(:,:,i), tau, n_sample_ransac);
end

%% PLOTS
% ransac histogram r = 5 %
figure(1)
subplot(2, 4, 1);
histogram(result_ransac(:,1,1));
xlim([0 100])
% ransac histogram r = 20 %
subplot(2, 4, 2);
histogram(result_ransac(:,1,2));
xlim([0 100])
% ransac histogram r = 30 %
subplot(2, 4, 3);
histogram(result_ransac(:,1,3));
xlim([0 100])
% ransac histogram r = 70 %
subplot(2, 4, 4);
histogram(result_ransac(:,1,4));
xlim([0 100])

% ransac best result r = 5 %
subplot(2, 4, 5);
PlotBestRansacResult(data(:,:,1), [x_c, y_c], radius, tau, best_result_ransac(:,:,1), domain);
subplot(2, 4, 6);
PlotBestRansacResult(data(:,:,2), [x_c, y_c], radius, tau, best_result_ransac(:,:,2), domain);
subplot(2, 4, 7);
PlotBestRansacResult(data(:,:,3), [x_c, y_c], radius, tau, best_result_ransac(:,:,3), domain);
subplot(2, 4, 8);
PlotBestRansacResult(data(:,:,4), [x_c, y_c], radius, tau, best_result_ransac(:,:,4), domain);
