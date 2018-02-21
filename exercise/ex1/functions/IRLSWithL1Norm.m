function [ x, num_iter, res ] = IRLSWithL1Norm( data, tol, max_iter )
    %IRLSWITHL1NORM
    
    % data   N x 2 matrix. each row vector is [x, y]
    N = size(data, 1);
    
    data_x = data(:,1);
    data_y = data(:,2);
    
    % initial W
    W = eye(N); 
    
    % result [a, b]
    x = zeros(1, 2);
    
    for i=1:max_iter
        % min (Ax - b)' * W * (Ax - b)
        % solve weighted least square problem
        A = [data_x, ones(N, 1)];
        b = data_y;
        
        % update x
        x_prev = x;
        x = (A' * W * A)\ A' * W * b;
        
        % update W (for next step) 
        a_curr = x(1);     % a_t
        b_curr = x(2);     % b_t
        
        % w is vector of w_i = 1/2 * d((a_t,b_t),(x_i,y_i))^-1
        % d((a_t,b_t),(x_i,y_i)) = (y_i - a_t * x_i - b_t)
        w = 1/2 * Cost('vertical', data(:,:), [a_curr, b_curr]).^(-1);
        W = diag(w);
        
        if norm(x - x_prev) < tol
            break
        end
    end
    
    num_iter = i;
    res = (A * x - b)' * W * (A * x - b);
end

