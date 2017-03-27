function [ deformed_img ] = RigidTransform( p, q, img, alpha )
    %RIGIDTRANSFORM 
    
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
            
            % calculate Ai
            p_hat_orth = [-p_hat(:, 2), p_hat(:, 1)];
            v_p_star = v - p_star;
            v_p_star_orth = [-v_p_star(:, 2), v_p_star(:, 1)];
                        
            % fr(v) = sigma_i (sigma_term) + q_star
            sigma_term = zeros(n, 2);
            
            for i=1:n
                % calculate Ai
                Ai = w(i) * [p_hat(i, :); -p_hat_orth(i, :)] ...
                    * [v_p_star; -v_p_star_orth]';
                
                % sigma_term
                sigma_term(i, :) = q_hat(i, :) * Ai;
            end
            
            fr_v_vector = sum(sigma_term, 1);
            fr_v = norm(v - p_star) * fr_v_vector / norm(fr_v_vector) + q_star;
            
            % round fs(v)
            fr_v = round(fr_v);
            
            if fr_v(1) > 0 && fr_v(2) > 0 && ...
                    fr_v(1) < size(img, 2) && fr_v(2) < size(img, 1)
                % check bound
                deformed_img(vy, vx, :) = img(fr_v(2), fr_v(1), :);
            end
        end
    end
end
