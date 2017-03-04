function [ inlier_vectors ] = GenerateInlierData( N, r, circle_param, noise_radius)
    %GENERATEDATA
    
    % circle_param  [x_c, y_c, radius]
    x_c = circle_param(1);
    y_c = circle_param(2);
    radius = circle_param(3);
    
    % number of inlier
    n_inlier =int32(N * (1 - r / 100));
    
    % generate along circle line 
    theta_vec = rand(n_inlier, 1) * pi() * 2;
    x_vec = radius * cos(theta_vec) + x_c;
    y_vec = radius * sin(theta_vec) + y_c;
    
    % add nose (TODO check requirement!)
    x_noise_vec = rand(n_inlier, 1) * 2 - 1;
    y_noise_vec = rand(n_inlier, 1) * 2 - 1;
    normalized_noise_vec = normc([x_noise_vec, y_noise_vec]')' * noise_radius;
    
    x_vec = x_vec + normalized_noise_vec(:,1);
    y_vec = y_vec + normalized_noise_vec(:,2);
    
    % inlier vector
    inlier_vectors = [x_vec, y_vec];
end

