function [ fs_v_array ] = SimilarTransform( p, q, img_h, img_w, alpha )
    %SIMILARTRANSFORM 
    
    % p     m x 2   selected control points
    % q     m x 2   deformed control points
    
    % the shape of fs_v_array is same with img
    % fs_v_array(y, x, :) = fs([x, y]) 
    fs_v_array = zeros(img_h, img_w, 2);
    
    % number of control points
    n = size(p, 1);
    
    for vx = 1:img_w
        for vy = 1:img_h
            
            % v point from image
            v = [vx, vy];
            
            sqd_pi_v = pdist2(p, v, 'squaredeuclidean');    % ith row = norm(pi - v)^2
            w = 1 ./ (sqd_pi_v .^ alpha);                   % ith row = wi
            
            % calculate p_star and q_star
            % w is column vector
            p_star = (w' * p) / sum(w);
            q_star = (w' * q) / sum(w);
            
            p_hat = p - p_star;
            q_hat = q - q_star;
            
            % calculate mu_s 
            mu_s_i = zeros(n, 1);
            
            for i=1:n
                 mu_s_i(i) = w(i) * p_hat(i, :) * p_hat(i, :)';
            end
            
            mu_s = sum(mu_s_i);
            
            % calculate Ai and fs(v)            
            p_hat_orth = [-p_hat(:, 2), p_hat(:, 1)];
            v_p_star = v - p_star;
            v_p_star_orth = [-v_p_star(:, 2), v_p_star(:, 1)];
                        
            % fs(v) = sigma_i (sigma_term) + q_star
            sigma_term = zeros(n, 2);
            
            for i=1:n
                % calculate Ai
                Ai = w(i) * [p_hat(i, :); -p_hat_orth(i, :)] ...
                    * [v_p_star; -v_p_star_orth]';
                
                % sigma_term
                sigma_term(i, :) = q_hat(i, :) * (1/mu_s * Ai);
            end
            
            fs_v = sum(sigma_term, 1) + q_star;
            
            % round fs(v)
            fs_v = round(fs_v);
            
            fs_v_array(vy, vx, 1) = fs_v(1);
            fs_v_array(vy, vx, 2) = fs_v(2);
        end
    end
end

