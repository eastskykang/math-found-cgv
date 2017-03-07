function [ x ] = LinProgWithLqNorm( norm, data )
    %LINPROGWITHLQNORM 
    
    % data   N x 2 matrix. each row vector is [x, y]
    N = size(data, 1);
    
    % x vector, y vector (decompose into column vectors)
    data_x = data(:,1);
    data_y = data(:,2);
    
    if strcmp(norm, 'L1')
        % solving (min f'x) w.r.t (Ax <= b)
        % arg x = [a b 0 0 ... 0 t_i 0 ... 0]

        % build A matrix
        A1 = - [data_x, ones(N ,1), eye(N)];
        A2 = [data_x, ones(N, 1), -eye(N)];
        A = [A1; A2];
        
        % build b vector
        b = [-data_y; data_y];
        
        % build f vector
        f = [zeros(2, 1); ones(N, 1)];
        
        % linear programming
        x = linprog(f, A, b);
        
    elseif strcmp(norm, 'Linf')
        % solving (min f'x) w.r.t (Ax <= b)
        % arg x = [a b t]

        % build A matrix
        A1 = - [data_x, ones(N ,1), ones(N ,1)];
        A2 = [data_x, ones(N, 1), -ones(N ,1)];
        A = [A1; A2];
        
        % build b vector
        b = [-data_y; data_y];
        
        % build f vector
        f = [0; 0; 1];
        
        % linear programming
        x = linprog(f, A, b);
        
    else
        error('wrong argument for lin_prog_with_lq_norm')
    end
    
    % return parameter only
    x = x(1:2);
end

