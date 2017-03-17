function VisualizeMatch( padding, img_left, img_right, p_left, p_right, ...
        inliers_left, inliers_right, outliers_left, outliers_right)
    %VISUALIZEOPT
    
    % padding   black padding between left image and right image
    % p_left    n x 2 
    % p_right   n x 2
    
    [img_left_h, img_left_w, ~] = size(img_left);
    [img_right_h, img_right_w, ~] = size(img_right);

    % visualize correspondence
    img = [img_left, zeros(img_left_h, padding, 3), img_right];
    
    pt_l = p_left;
    pt_r = p_right + [img_left_w, 0] + [padding, 0];
    
    figure(1)
    subplot(2,1,1), subimage(img)
    hold on
    line([pt_l(:,1)'; pt_r(:,1)'], [pt_l(:,2)'; pt_r(:,2)'], 'Color', 'blue');
    hold off
    
    % visualize inlier
    
    in_l = inliers_left;
    in_r = inliers_right + [img_left_w, 0] + [padding, 0];
    out_l = outliers_left;
    out_r = outliers_right + [img_left_w, 0] + [padding, 0];
    
    subplot(2,1,2), subimage(img)
    hold on 
    line([out_l(:,1)'; out_r(:,1)'], [out_l(:,2)'; out_r(:,2)'], 'Color', 'red');
    line([in_l(:,1)'; in_r(:,1)'], [in_l(:,2)'; in_r(:,2)'], 'Color', 'green');
    hold off 
    
end

