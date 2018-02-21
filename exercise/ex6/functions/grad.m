function [ grad_f ] = grad( f, I_size )
    %GRAD     
    
    if size(f, 1) ~= I_size(1) * I_size(2) 
        error('grad: size error')
    end
    
    % f is N x 1        or  N x 1 x 3 (RGB)
    % size is h x w     
    
    h = I_size(1);
    w = I_size(2);
    c = size(f, 3);
    
    if c == 1 || c == 3
        f = reshape(f, h, w, c);

        % get forward differences
        grad_f1 = diff(f, 1, 2);     % x dir
        grad_f2 = diff(f, 1, 1);     % y dir
        
        % Neumann boundary condition
        grad_f1 = padarray(grad_f1, [0, 1], 0, 'post');
        grad_f2 = padarray(grad_f2, [1, 0], 0, 'post');
        
        % output grad_f is N x 2 x 3
        grad_f = [reshape(grad_f1, [], 1, c), ...
            reshape(grad_f2, [], 1, c)];
    else
        error('grad: channel error')        
    end
end

