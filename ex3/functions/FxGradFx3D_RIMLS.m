function [ FxGradFx ] = FxGradFx3D_RIMLS( X_mat, V_mat, N_mat, ...
        sigma, sigma_r, sigma_n, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % from the paper: Feature Preserving Point Set Surfaces based on
    % Non-Linear Kernel Regression
    
    % X_mat     n x 3 matrix    grid points
    % V_mat     m x 3 matrix    sample points
    % N_mat     m x 3 matrix    normal vectors (samples)
    
    % anno
    anno = ann(V_mat');
    
    % calculate h
    h = Calh(V_mat, 4);
    
    % gradFx    3 x n
    gradFx_mat = zeros(3, size(X_mat, 1));
    % Fx        3 x n
    Fx_mat = zeros(3, size(X_mat, 1));
    
    for idx = 1:size(X_mat, 1)
        % idx is index of given point x = (x1, x2, x3)
        
        X = X_mat(idx, :);  % x = (x1, x2, x3)
        
        % finding neighbors
        [j, ~, ~] = frsearch(anno, X', sigma * 3, size(V_mat, 1), 0);
        
        p_position = V_mat(j, :);
        p_normal = N_mat(j, :);
        
        for iter = 1:10
            
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
                else
                    alpha_vec = 1;
                end
                
                % phi = (1 - norm(px)^2 / h^2) ^ 4;
                phi = exp(-norm(px)^2 / (h^2));
                
                w = alpha_vec * phi;
                
                % dphi = -8/(h^2) * px * (1 - norm(px)^2 / h^2)^3;
                dphi = (-2/h^2) * phi * px;
                
                grad_w = alpha_vec * dphi;
                
                sumW = sumW + w;
                sumGw = sumGw + grad_w;
                sumF = sumF + w * fx;
                sumGF = sumGF + grad_w * fx;
                sumN = sumN + w * Ni;
            end
            
            f = sumF / sumW;
            grad_f = (sumGF - f * sumGw + sumN) / sumW;
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

