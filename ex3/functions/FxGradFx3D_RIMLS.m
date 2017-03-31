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
    
    % calculate h
    D = squareform(pdist(V_mat));
    D = reshape(D(D~=0), size(V_mat, 1) - 1, []);
    h = 1.4 * mean(min(D));
        
    X_out = zeros(size(X_mat));
        
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        for iter_out = 1:5
            % finding neighbors
            [j, ~, ~] = frsearch(anno, X', sigma, size(V_mat, 1), 0);
          
            p_position = V_mat(j, :);
            p_normal = N_mat(j, :);
            
            for iter = 1:5    
                
                sumW = 0;
                sumGw = [0, 0, 0];
                sumF = 0;
                sumGF = [0, 0, 0];
                sumN = [0, 0, 0];
                
                for i = 1:size(p_position, 1)
                    Xi = p_position(i, :);   % 1 x 3
                    Ni = p_normal(i, :);   % 1 x 3
                    
                    px = (X - Xi);       % 1 x 3
                    fx = dot(px, Ni);    % 1 x 1
                    
                    if iter > 1
                        alpha_vec = exp(-((fx-f)/sigma_r) ^2) * ...
                            exp(-(norm(Ni - grad_f)/sigma_n) ^2);
                        
                        disp(alpha_vec)
                    else
                        alpha_vec = 1;
                    end
                    
                    phi = (1 - norm(px)^2 / h^2) ^ 4;
                    w = alpha_vec * phi;
                    
                    dphi = -8/(h^2) * px * (1 - norm(px)^2 / h^2)^3;
                    grad_w = alpha_vec * dphi;
                    
                    sumW = sumW + w;
                    sumGw = sumGw + grad_w;
                    sumF = sumF + w * fx;
                    sumGF = sumGF + grad_w * fx;
                    sumN = sumN + w * Ni;
                end
                
                f = sumF / sumW;
                grad_f = (sumGF - f * sumGw + sumN) / sumW;
                
%                 if iter > 0 && ...
%                         max(abs(alpha_vec ./ sum(alpha_vec) - prev_alpha ./ sum(prev_alpha))) < 1e-4
%                     % until alpha converged
%                     break
%                 end
            end
            
            FxGradFx = f * grad_f;
            X = X - FxGradFx;
            
            disp(['idx = ', num2str(idx), ' ', ...
                'iter_out = ', num2str(iter_out), ' ', ...
                'j = ', num2str(i), ' '])
            disp(alpha_vec)
            disp(FxGradFx)
            
            if norm(FxGradFx) < 1e-10
                % converged
                break
            end
        end
        
        X_out(idx, :) = X;
    end
end

