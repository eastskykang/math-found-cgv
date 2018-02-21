function [ FxGradFx ] = FxGradFx3D_RIMLS( X_mat, V_mat, N_mat, ...
        sigma_r, sigma_n, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % from the paper: Feature Preserving Point Set Surfaces based on
    % Non-Linear Kernel Regression
    
    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sample points
    % N_mat     m x 3 matrix    normal vectors (samples)
    
    % parameters
    max_iter = 10;
    
    % anno
    anno = ann(V_mat');
    
    % calculate h
    h = Calh(V_mat, 2);
    
    % gradFx    3 x n
    gradFx_mat = zeros(3, size(X_mat, 1));
    % Fx        3 x n
    Fx_mat = zeros(3, size(X_mat, 1));
    
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        % finding neighbors
        [j, sqd_X_Xi, inr] = frsearch(anno, X', h * 3, size(V_mat, 1), 0);
        
        for iter = 1:max_iter
            
            Ni = N_mat(j, :)';              
            Xi = V_mat(j, :)';
            
            px = (X' - Xi);         % 3 x inr
            fx = dot(px, Ni);       % 1 x inr
            
            if iter > 1
                prev_alpha = alpha_vec;
                alpha_vec = exp(-((fx-f)/sigma_r) .^2) .* ...
                    exp(-(sqrt(dot(Ni - grad_f, Ni - grad_f))/sigma_n) .^2);
            else
                alpha_vec = ones(1, inr);
            end
            
            % phi = (1 - norm(px)^2 / h^2) ^ 4;
            phi = exp(- sqd_X_Xi / (h^2));
            w = alpha_vec .* phi;
            
            % dphi = -8/(h^2) * px * (1 - norm(px)^2 / h^2)^3;
            dphi = (-2/h^2) * phi .* px;
            grad_w = alpha_vec .* dphi;
            
            sumW = sum(w);
            sumGw = sum(grad_w, 2);
            sumF = sum(w .* fx);
            sumGF = sum(grad_w .* fx, 2);
            sumN = sum(w .* Ni, 2);
            
            % f         scalar
            f = sumF / sumW;
            % grad_f    3 x 1
            grad_f = (sumGF - f * sumGw + sumN) / sumW;
            
            if iter > 1 && ...
                    max(abs(alpha_vec / sum(alpha_vec) - prev_alpha / sum(prev_alpha))) < 1e-4
                % until alpha converged
                break
            end
        end
        
        Fx_mat(:, idx) = f;
        gradFx_mat(:, idx) = grad_f;
    end
    
    FxGradFx = Fx_mat .* gradFx_mat;
    % FxGradFx  n x 3
    FxGradFx = FxGradFx';
end


function [ h ] = Calh(V_mat, coeff)
    D = squareform(pdist(V_mat));
    D = reshape(D(D~=0), size(V_mat, 1) - 1, []);
    h = coeff * mean(min(D));
end

