function [ nb_inlier_lb ] = ComputeInlierLb( p_left, p_right, Tx, Ty, thres )
    %COMPUTEINLIERLB compute low bound of the number of inliers
    
    nb_inlier_lb = nnz(FindInliers(p_left, p_right, Tx, Ty, thres));
end

