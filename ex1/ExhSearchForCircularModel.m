function [ result ] = ExhSearchForCircularModel( data, tau, n_sample_ransac )
    %EXHSEARCHFORCIRCULARMODEL Exhaustive search for circular model
       
    samples_idx = nchoosek(1:size(data, 1), n_sample_ransac);
    
    % best results [n_inlier, n_outlier, a, b, c]
    % a, b, c are parameters for circle 
    result = zeros(1, 5);
    
    for j=1:size(samples_idx, 1)
        samples = data(samples_idx(j,:)', :);
        
        % model fitting
        result = CircularModelFitting(tau, samples, data, result);
    end
    
end

