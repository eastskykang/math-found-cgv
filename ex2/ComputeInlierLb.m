function [ nb_inlier_lb ] = ComputeInlierLb( p_left, p_right, Tx, Ty, thres )
    %COMPUTEINLIERLB compute low bound of the number of inliers
    
    x_left = p_left(:, 1);
    y_left = p_left(:, 2);
    
    x_right = p_right(:, 1);
    y_right = p_right(:, 2);
    
    nb_inlier_lb = nnz((abs(x_left + Tx - x_right) <= thres) & ...
        (abs(y_left + Ty - y_right) <= thres));
end

