function [ inlier_vectors ] = GenerateInlierData(model ,N, r, tau, domain_param, model_param, noise_radius)
    %GENERATEDATA
    
    % domain param  [x_min, x_max, y_min, y_max]
    x_min = domain_param(1);
    x_max = domain_param(2);
    y_min = domain_param(3);
    y_max = domain_param(4);
    
    % number of inlier
    n_inlier =int32(N * (1 - r / 100));    
    
    if strcmp(model, 'circle')
        if ~eq(size(model_param), [1, 3])
            error('wrong model_param for generation_inlier_data')
        end
        
        % circle_param [x_c, y_c, radius]
        x_c = model_param(1);
        y_c = model_param(2);
        radius = model_param(3);

        % generate along circle line
        theta_vec = rand(n_inlier, 1) * pi() * 2;
        x_vec = radius * cos(theta_vec) + x_c;
        y_vec = radius * sin(theta_vec) + y_c;
      
    elseif strcmp(model, 'line')
        if ~eq(size(model_param), [1, 2])
            error('wrong model_param for generation_inlier_data')
        end
        
        % line_param [a, b]
        a = model_param(1);
        b = model_param(2);
        
        % generate along line 
        x_vec = rand(n_inlier, 1) * (x_max - x_min) + x_min;
        y_vec = a * x_vec + b;
        
    else
        error('wrong argument for generation_inlier_data')
    end
    
    % add noise
    idx = 1;
    x_vec_noise_added = zeros(n_inlier, 1);
    y_vec_noise_added = zeros(n_inlier, 1);
    
    while idx <= n_inlier
        
        x_noise_vec = rand() * 2 - 1;
        y_noise_vec = rand() * 2 - 1;
        normalized_noise_vec = [x_noise_vec, y_noise_vec] * noise_radius;
        
        x_vec_temp = x_vec(idx) + normalized_noise_vec(1);
        y_vec_temp = y_vec(idx) + normalized_noise_vec(2);
        
        if ~((x_min <= x_vec_temp && x_vec_temp <= x_max) && ...
                (y_min <= y_vec_temp && y_vec_temp <= y_max))
            % check noise added vector is outside of the domain
            continue
        end
        
        if ~VerifyInlier(model, model_param, tau, [x_vec_temp, y_vec_temp])
            % check nodise added vector is not over threshold
            continue
        end
       
        x_vec_noise_added(idx) = x_vec_temp;
        y_vec_noise_added(idx) = y_vec_temp;
        idx = idx + 1;
    end
    
    % inlier vector
    inlier_vectors = [x_vec_noise_added, y_vec_noise_added];
end

