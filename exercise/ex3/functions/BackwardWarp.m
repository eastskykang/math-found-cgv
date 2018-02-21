function [ deformed_img ] = BackwardWarp( f_v_array, img )
    %BACKWARDWARP backward warping by regression inverse transform function
    
    img_w = size(img, 2);
    img_h = size(img, 1);
    
    % create grid points
    % these are query points for v'
    [xq, yq] = meshgrid(1:img_w, 1:img_h);
    
    f_v_array_x = f_v_array(:, :, 1);
    f_v_array_y = f_v_array(:, :, 2);
    
    % filtering nan values (created by singular cases)
    vx = xq(~isnan(f_v_array_x));
    vy = yq(~isnan(f_v_array_y));
    
    f_v_array_x = f_v_array_x(~isnan(f_v_array_x));
    f_v_array_y = f_v_array_y(~isnan(f_v_array_y));
    
    % regression f_inv function and get v = f_inv([vx, vy])
    v_q_x = griddata(f_v_array_x(:), f_v_array_y(:), vx, xq, yq);
    v_q_y = griddata(f_v_array_x(:), f_v_array_y(:), vy, xq, yq);
    
    % backward warping
    deformed_img = zeros(size(img));
    
    for i = 1:size(xq(:), 1)
        
        % v'
        v_dash = [xq(i), yq(i)];
        
        % v = f_inv(v')
        inversed_v = [v_q_x(i), v_q_y(i)];
        inversed_v = round(inversed_v);     % round v
        
        if inversed_v(1) > 0 && inversed_v(2) > 0 && ...
                inversed_v(1) < size(img, 2) && inversed_v(2) < size(img, 1)
            % check bound
            deformed_img(v_dash(2), v_dash(1), :) = img(inversed_v(2), inversed_v(1), :);
        end
    end
    
    deformed_img = uint8(deformed_img);
end

