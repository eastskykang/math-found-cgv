function [ outlier_vectors ] = GenerateOutlierData( model, N, r, tau, domain_param, model_param )
    %GENERATEOUTLIERDATA
    
    % domain param  [x_min, x_max, y_min, y_max]
    x_min = domain_param(1);
    x_max = domain_param(2);
    y_min = domain_param(3);
    y_max = domain_param(4);
    
    % number of outlier
    n_outlier = int32(N * (r / 100));
    
    % outlier vector
    outlier_vectors = zeros(n_outlier, 2);
    
    if strcmp(model, 'circle')
        if ~eq(size(model_param), [1, 3])
            error('wrong model_param for generation_outlier_data')
        end
    elseif strcmp(model, 'line')
        if ~eq(size(model_param), [1, 2])
            error('wrong model_param for generation_outlier_data')
        end
    else
        error('wrong argument for generation_outlier_data')
    end
    
    % generate outlier
    idx = 1;    % index for outliers
    
    while idx <= n_outlier
        
        x_outlier = rand() * (x_max - x_min) + x_min;
        y_outlier = rand() * (y_max - y_min) + y_min;
        outlier_vector = [x_outlier, y_outlier];
        
        if ~VerifyInlier(model, model_param, tau, outlier_vector)
            % outlier (over threshold)
            outlier_vectors(idx, :) = outlier_vector;
            idx = idx + 1;
        end
    end
end

