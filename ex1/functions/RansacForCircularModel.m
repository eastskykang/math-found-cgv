function [ best_result ] = RansacForCircularModel( data, succ_rate, r, tau, n_sample_ransac, debug )
    %RANSACFORCIRCULARMODEL
    
    % data              N x 2 matrix which of row vectors are data (x, y)
    % succ_rate         success rate for RANSAC (prob that at least one sam
    %                   ple has no outlier) (0 < succ_rate < 1)
    % r                 outlier ratio (%)
    % n_sample_ransac   number of minimum data for model fitting (3 for cir
    %                   cle)
    %
    % result            1 x 5 matrix. best result of RANSAC interation. 
    
    n_iter = ceil(log(1 - succ_rate) / log(1 - (1 - r/100)^n_sample_ransac));
    
    if debug 
        disp(['# of ransac iter = ', num2str(n_iter)]);
    end
    
    % results [n_inlier, n_outlier, a, b, c] 
    % a, b, c are parameters for circle 
    best_result = zeros(1, 5);
    
    for i=1:n_iter
        
        % n_sample_ransac(=3) number of samples from data
        samples = datasample(data, n_sample_ransac, 'Replace', false);
        
        if debug
            disp(samples);
        end
        
        % model fitting
        result = CircularModelFitting(tau, samples, data);
        n_inlier_fitted = result(1);
        
        if debug
            disp('result =')
            disp(result);
        end
        
        if n_inlier_fitted > best_result(1)
            best_result = result;
        end 
    end
    
    if debug 
        disp('best result of RANSAC = ')
        disp(best_result);
    end
end

