function [ result ] = CircularModelFitting( tau, samples, data )
    %CIRCLULARMODELFITTING
    
    % results      [n_inlier, n_outlier, a, b, c]
    
    % model fitting for (x - a)^2 + (y - b)^2 = c^2
    % find solution x = (a; b) from Ax = B
    %
    % A = [-2(x1 - x2), -2(y1 - y2); -2(x2 - x3), -2(y2 - y3)]
    % B = [x2^2 - x1^2 + y2^2 - y1^2; x3^2 - x2^2 + y3^2 - y2^2]
    
    A = (-2) * [samples(1,:) - samples(2, :); samples(2,:) - samples(3,:)];
    B = [sum(samples(2,:).^2) - sum(samples(1,:).^2); sum(samples(3,:).^2) - sum(samples(2,:).^2)];
    
    % center (x, y) of fitted circle
    fitted_center = A \ B;
    
    % c^2 = x1^2 + y1^2 + a^2 + b^2 - 2*a*x1 - 2*b*y1
    % c is radius of fitted circle
    fitted_radius = sqrt(...
        sum(samples(1,:).^2) + sum(fitted_center.^2) - 2 * samples(1, :) * fitted_center);
    
    n_inlier_fitted = nnz(abs(pdist2(data, fitted_center') - fitted_radius) <= tau);
    n_outlier_fitted = nnz(abs(pdist2(data, fitted_center') - fitted_radius) > tau);
    
    result = [n_inlier_fitted, n_outlier_fitted, fitted_center(1), fitted_center(2), fitted_radius];
end

