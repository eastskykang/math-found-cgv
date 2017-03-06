function cost = Cost(cost_model, sample, model_param )
    %COSTFORLINEFITTING 
    
    if ~eq(size(model_param), [1, 2])
        error('wrong model_param for generation_inlier_data')
    end
    
    % line_param [a, b]
    a = model_param(1);
    b = model_param(2);
    
    x_i = sample(:,1);
    y_i = sample(:,2);
    
    if strcmp(cost_model, 'vertical')
        cost = y_i - (a * x_i + b);
    else
        error('wrong argument for cost_for_line_fitting')
    end
end

