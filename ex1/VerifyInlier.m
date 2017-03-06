function flagYN = VerifyInlier( model, model_param, tau, vector )
    %VERIFYINLIER
    % return true(1) for inlier, false(0) for outlier
    
    if strcmp(model, 'circle')
        if ~eq(size(model_param), [1, 3])
            error('wrong model_param for generation_inlier_data')
        end
        
        % circle_param [x_c, y_c, radius]
        x_c = model_param(1);
        y_c = model_param(2);
        radius = model_param(3);
        
        flagYN = abs((pdist2(vector, [x_c, y_c]) - radius)) <= tau;
                
    elseif strcmp(model, 'line')
        if ~eq(size(model_param), [1, 2])
            error('wrong model_param for generation_inlier_data')
        end
        
        % line_param [a, b]
        a = model_param(1);
        b = model_param(2);
        
        flagYN = abs(Cost('vertical', vector, [a,b])) <= tau;
        
    else
        error('wrong argument for verify_inlier')
    end
end
