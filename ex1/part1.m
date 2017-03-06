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

for i=1:size(r_array, 2)
    %% DATA GENERATION
    % outlier_ratio
    r = r_array(i);
    n_inlier = int32(N * (1 - r/100));
    n_outlier = int32(N * r/100);
    
    disp('======================================')
    disp(['data generating for r = ', num2str(r)])
    
    % inlier_vector
    inlier_vectors = GenerateInlierData('circle', N, r, tau, domain, [x_c, y_c, radius], noise_radius);    

    % outlier_vector
    outlier_vectors = GenerateOutlierData('circle', N, r, tau, domain, [x_c, y_c, radius]);
    
    disp('data verifying... ')
    
    % data verification
    n_inlier_verified = nnz(VerifyInlier('circle', [x_c, y_c, radius], tau, inlier_vectors));
    n_outlier_verified = nnz(~VerifyInlier('circle', [x_c, y_c, radius], tau, outlier_vectors));
    
    % assert error if number of inliers/outliers are different with setup
    assert(n_inlier_verified == n_inlier);
    assert(n_outlier_verified == n_outlier);
    assert(n_inlier_verified + n_outlier_verified == N);
    
    disp(['data verified! (# of inlier = ', num2str(n_inlier), ', # of outlier = ', num2str(n_outlier), ')'])
    disp(' ')
    
    % generated data
    data(:,:,i) = [inlier_vectors; outlier_vectors];   

    %% RANSAC    
    disp(['RANSAC... (# of test = ', num2str(n_test_ransac), ')'])
    
    for j=1:n_test_ransac
        result_ransac(j,:,i) = RansacForCircularModel(data(:,:,i), succ_rate, r, tau, n_sample_ransac, debug);
        
        if result_ransac(j,1,i) > best_result_ransac(1,1,i)
            % best result update
            best_result_ransac(:,:,i) = result_ransac(j,:,i);
        end
    end
    
    disp('best_result = ')
    disp(best_result_ransac(:,:,i))
    
    %% EXHAUSTIVE SEARCH
%     result_exh_search(i,:) = ExhSearchForCircularModel(data(:,:,i), tau, n_sample_ransac);
end

%% PLOTS
disp('======================================')
disp('plot...')

figure(1)

% ransac histogram
for i=1:size(r_array, 2)
    subplot(2, 4, i);
    hist(result_ransac(:,1,i), 0:N);
    xlim([0 100])
    xlabel('Nb of detected inliers')
    ylabel('Nb of experiments')
end

% ransac best result
for i=1:size(r_array, 2)
    subplot(2, 4, i + size(r_array, 2));
    PlotBestRansacResult(data(:,:,i), [x_c, y_c], radius, tau, best_result_ransac(:,:,i), domain);
end