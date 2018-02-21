function [ inlier_mask ] = FindInliers( p_left, p_right, Tx, Ty, thres )
    %FINDINLIERSOUTLIERS return inlier_mask (0/1)
    
    x_left = p_left(:, 1);
    y_left = p_left(:, 2);
    
    x_right = p_right(:, 1);
    y_right = p_right(:, 2);
    
    inlier_mask = (abs(x_left + Tx - x_right) <= thres) & ...
        (abs(y_left + Ty - y_right) <= thres);
end

