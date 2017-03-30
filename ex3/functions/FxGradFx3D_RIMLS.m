function [ X_out ] = FxGradFx3D_RIMLS( X_mat, V_mat, N_mat, ...
        sigma, sigma_r, sigma_n, max_iter, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % from the paper: Feature Preserving Point Set Surfaces based on
    % Non-Linear Kernel Regression
    
    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sample points
    % N_mat     m x 3 matrix    normal vectors (samples)
    
    % gradFx  3 x n
    %     FxGradFx_array = zeros(3, size(X_mat, 1));
    
    % anno
    anno = ann(V_mat');
    
    X_out = zeros(size(X_mat));
        
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        for iter_out = 1:max_iter
            % finding neighbors
            [j, sqd_X_Xi, inr] = frsearch(anno, X', sigma, size(V_mat, 1), 0);
            
            for iter = 0:1
                
                Xi = V_mat(j, :);   % inr x 3
                Ni = N_mat(j, :)';  % 3 x inr
                
                px = (X - Xi)';      % 3 x inr
                fx = dot(px, Ni);    % 1 x inr
                
                if iter > 0
                    % 1 x inr
                    prev_alpha = alpha_vec;
                    
                    alpha_vec = exp(-((fx-f)/sigma_r) .^2) .* ...
                        exp(-(sqrt(dot(Ni - grad_f, Ni - grad_f))/sigma_n) .^2);
                else
                    alpha_vec = ones(1, inr);
                end
                
                % sqd_X_Xi  1 x inr
                
                h = 1.4 * sqrt(max(sqd_X_Xi));
                % phi   1 x inr
                phi = (1 - sqd_X_Xi / h^2) .^ 4;
%                 phi = exp( - sqd_X_Xi / h^2);
                w = alpha_vec .* phi;
                
                % dphi   1 x inr
                dphi = -8/(h^2) * px .* (1 - sqd_X_Xi / h^2).^3;
%                 dphi = -2/(h^2) * px' .* exp(- sqd_X_Xi / h^2);
                grad_w = alpha_vec .* dphi;
                
                sumW = sum(w);
                sumGw = sum(grad_w, 2);
                sumF = sum(fx);
                sumGF = sum(grad_w .* fx, 2);
                sumN = sum(Ni, 2);
                
                f = sumF / sumW;
                grad_f = (sumGF - f * sumGw + sumN) / sumW;
                
                if iter > 0 && ...
                        max(abs(alpha_vec ./ sum(alpha_vec) - prev_alpha ./ sum(prev_alpha))) < 1e-4
                    % until alpha converged
                    break
                end
            end
            
            FxGradFx = f * grad_f;
            %             FxGradFx_array(:, idx) = FxGradFx;
            
            if norm(FxGradFx) < 1e-4
                % converged
                break
            end
        end
        
        X_out(idx, :) = X - FxGradFx';
    end
end

