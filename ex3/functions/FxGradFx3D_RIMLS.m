function [ FxGradFx ] = FxGradFx3D_RIMLS( X_mat, V_mat, N_mat, ...
        sigma, sigma_r, sigma_n, max_iter, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % from the paper: Feature Preserving Point Set Surfaces based on
    % Non-Linear Kernel Regression
    
    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sample points 
    % N_mat     m x 3 matrix    normal vectors (samples)
            
    % gradFx  3 x n 
    FxgradFx = zeros(3, size(X_mat, 1));
    
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        x = X_mat(idx, :);  % x = (x1, x2, x3)
        
        pre_alpha = 0;
        for i = 0:max_iter
            sumW = 0;
            sumGw = 0;
            sumF = 0;
            sumGF = 0;
            sumN = 0;
            
            for j = 1:size(V_mat, 1)
                p_position = V_mat(j, :);
                p_normal = N_mat(j, :);
                
                px = x - p_position;
                fx = dot(px, p_normal);
                
                if i>0 
                    alpha = exp(-((fx-f)/sigma_r)^2) * ...
                        exp(-(norm(p_normal - grad_f)/sigma_n)^2);
                else
                    alpha = 1;
                end
                
                phi = (1 - norm(x - p_position)^2 / sigma^2)^4;
                w = alpha * phi;
                
                dphi = -4/(sigma^2) * (1 - norm(x - p_position)^2 / sigma^2)^3;
                grad_w = alpha * 2 * px * dphi;
                
                sumW = sumW + w;
                sumGw = sumGw + grad_w;
                sumF = sumF + fx;
                sumGF = sumGF + grad_w * fx;
                sumN = sumN + p_normal;
            end
            f = sumF / sumW;
            grad_f = (sumGF - f * sumGw + sumN) / sumW;
            
            if abs(alpha - pre_alpha) < 1e-4
                break
            end
            
            pre_alpha = alpha;
        end
        
        FxgradFx(:, idx) = f * grad_f; 
    end
end

