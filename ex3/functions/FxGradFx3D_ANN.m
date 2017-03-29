function [ FxGradFx ] = FxGradFx3D_ANN ( X_mat, V_mat, N_mat, sigma, debug )

    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sampe points 
    % N_mat     m x 3 matrix    normal vectors (samples)
    
    % gradFx    3 x n 
    gradFx_mat = zeros(3, size(X_mat, 1));
    % Fx        3 x n
    Fx_mat = zeros(3, size(X_mat, 1));
    
    % anno
    anno = ann(V_mat');
    
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        % j is index in V_mat
        [i, sqd_X_Xi, inr] = frsearch(anno, X', sigma * 3, size(V_mat, 1), 0);

        % filtering
        i = i(1:inr);
        sqd_X_Xi = sqd_X_Xi(1:inr);
        
        Xi = V_mat(i, :);
        
        % vertex point v = (v1, v2, v3)
        Ni = N_mat(i, :)';                               % column j: (nj1, nj2, nj3)'
        X_Xi = (X - Xi)';                                % column j: (x1 - vj1, x2 - vj2, x3 - vj3)'
        
        % phi_i(x) = exp(...)
        phi_i = exp(-sqd_X_Xi / (sigma^2));
        
        % grad_phi_i(x)
        grad_phi_i = (-2/sigma^2) * phi_i .* X_Xi;
        
        % cal Fx 
        nomFx = sum(dot(Ni, X_Xi) .* phi_i);
        Fx = nomFx / sum(phi_i);

        Fx_mat(:, idx) = Fx;
        
        % cal Grad Fx
        nomGradFx = sum(...
            Ni .* phi_i + (dot(Ni, X_Xi) - Fx) .* grad_phi_i, 2);
        
        gradFx_mat(:, idx) = nomGradFx / sum(phi_i);
    end
    
    FxGradFx = Fx_mat .* gradFx_mat;
    % FxGradFx  n x 3
    FxGradFx = FxGradFx';
end

