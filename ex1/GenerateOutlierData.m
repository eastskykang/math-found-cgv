function [ outlier_vectors ] = GenerateOutlierData( N, r, tau, domain_param, circle_param )
    %GENERATEOUTLIERDATA
    
    % domain param  [x_min, x_max, y_min, y_max]
    x_min = domain_param(1);
    x_max = domain_param(2);
    y_min = domain_param(3);
    y_max = domain_param(4);
    
    % circle param  [x_c, y_c, radius]
    x_c = circle_param(1);
    y_c = circle_param(2);
    radius = circle_param(3);
    
    % number of outlier
    n_outlier = int32(N * (r / 100));
    
    idx = 1;    % index for outliers
    
    % outlier vector
    outlier_vectors = zeros(n_outlier, 2);
    
    while idx <= n_outlier
        
        x_outlier = rand() * (x_max - x_min) + x_min;
        y_outlier = rand() * (y_max - y_min) + y_min;
        outlier = [x_outlier, y_outlier];
        
        if abs(pdist2(outlier, [x_c, y_c]) - radius) > tau
            % outlier (over threshold)
            outlier_vectors(idx, :) = outlier;
            idx = idx + 1;
        end
    end
end

