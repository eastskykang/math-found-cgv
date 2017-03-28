function [ deformed_img ] = SimilarTransform( p, q, img, alpha )
    %SIMILARTRANSFORM 
    
    % p     m x 2   selected control points
    % q     m x 2   deformed control points
    
    % deformed img
    deformed_img = zeros(size(img));
    
    % number of control points
    n = size(p, 1);
    
    for vx = 1:size(img, 2)
        for vy = 1:size(img, 1)
            
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
            
            if fs_v(1) > 0 && fs_v(2) > 0 && ...
                    fs_v(1) < size(img, 2) && fs_v(2) < size(img, 1)
                % check bound
                % deformed_img(vy, vx, :) = img(fs_v(2), fs_v(1), :);
                deformed_img(fs_v(2), fs_v(1), :) = img(vy, vx, :);
            end
        end
    end
end

