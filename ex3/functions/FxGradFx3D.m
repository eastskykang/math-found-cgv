function [ FxGradFx ] = FxGradFx3D( X_mat, V_mat, N_mat, sigma, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sample points 
    % N_mat     m x 3 matrix    normal vectors (samples)
    
    % gradFx  3 x n 
    gradFx = zeros(3, size(X_mat, 1));
    
    % calculate C0 first 
    C0 = CalC0(X_mat, V_mat, N_mat, sigma, debug);
    
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        % vertex point v = (v1, v2, v3)
        Ni = N_mat';                                        % column j: (nj1, nj2, nj3)'
        sqd_X_Xi = pdist2(X, V_mat, 'squaredeuclidean');    % column j: squared_euc_dist(x, vj)
        X_Xi = (X - V_mat)';                                % column j: (x1 - vj1, x2 - vj2, x3 - vj3)'
        
        % phi_i(x) = exp(...)
        phi_i = exp(-sqd_X_Xi / (sigma^2));
        
        % grad_phi_i(x)
        grad_phi_i = (-2/sigma^2) * phi_i .* X_Xi;
        
        % nom
        nom = sum(...
            Ni .* phi_i + (dot(Ni, X_Xi) - C0(idx)) .* grad_phi_i, 2);
        
        gradFx(:, idx) = nom / sum(phi_i);
    end
    
    FxGradFx = C0 .* gradFx';
end

