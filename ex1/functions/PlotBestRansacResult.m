function PlotBestRansacResult( data, model_center, model_radius, tau, ...
    best_result_ransac, domain )
    % PLOTBESTRANSACRESULT
    
    % model_center          [x_c, y_c]
    % best_result_ransac    [n_inlier, n_outlier, a, b, c]
    % domain                [x_min, x_max, y_min, y_max]
    
    % theta (central angle)
    theta = 0:0.01:pi()*2;
    
    % synthetic model 
    x_syntetic = model_radius * cos(theta) + model_center(1);
    y_syntetic = model_radius * sin(theta) + model_center(2);
    
    % ransac model
    ransac_circle_center = [best_result_ransac(3), best_result_ransac(4)];
    ransac_circle_radius = best_result_ransac(5);
    
    x_ransac = ransac_circle_radius * cos(theta) + ransac_circle_center(1);
    y_ransac = ransac_circle_radius * sin(theta) + ransac_circle_center(2);
    
    inlier_vectors = data(abs(pdist2(data, ransac_circle_center) - ransac_circle_radius) <= tau, :);
    outlier_vectors = data(abs(pdist2(data, ransac_circle_center) - ransac_circle_radius) > tau, :);
    
    % plotting 
    plot(inlier_vectors(:, 1), inlier_vectors(:, 2), 'bo')
    hold on
    plot(outlier_vectors(:, 1), outlier_vectors(:, 2), 'ro')
    plot(x_ransac, y_ransac, 'k-')
    plot(x_syntetic, y_syntetic, 'g-')
    hold off
    axis equal tight
    axis(domain)
    legend('RANSAC inliers', 'RANSAC outliers', 'RANSAC model', 'synth. model', 'location', 'southoutside')
  
end

