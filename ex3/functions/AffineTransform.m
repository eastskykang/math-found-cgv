function [ fa_v_array ] = AffineTransform( p, q, img_h, img_w, alpha )
    %AFFINETRANSFORM
    
    % p     m x 2   selected control points
    % q     m x 2   deformed control points
    
    % the shape of fa_v_array is same with img
    % fa_v_array(y, x, :) = fa([x, y]) 
    fa_v_array = zeros(img_h, img_w, 2);
    
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
            
            % sigma i term: sum(p_hat_i' * w_i * p_hat_i)
            sum_phatT_w_phat = zeros(2, 2);
            
            for i = 1:size(p, 1)
                p_hat_i = p(i, :) - p_star;
                sum_phatT_w_phat = sum_phatT_w_phat + p_hat_i' * w(i) * p_hat_i;
            end
                        
            % calculate Aj
            Aj = zeros(n, 1);
            
            for j = 1:n
                % Aj is single scalar
                Aj(j) = (v - p_star) * (sum_phatT_w_phat \ (w(j) * p(j, :)'));
            end
            
            fa_v = sum(Aj .* (q - q_star), 1) + q_star;
            fa_v = round(fa_v);
            
            fa_v_array(vy, vx, 1) = fa_v(1);
            fa_v_array(vy, vx, 2) = fa_v(2);
        end
    end
end