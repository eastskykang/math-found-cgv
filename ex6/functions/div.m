function [ div_f ] = div( f, I_size )
    %DIV 
    
    if size(f, 1) ~= I_size(1) * I_size(2) 
        error('div: size error')
    end
    
    % f is N x 2        or  N x 2 x 3 (RGB)
    % size is h x w     
    
    h = I_size(1);
    w = I_size(2);
    c = size(f, 3);
    
    if c == 1 || c == 3
        f_1 = reshape(f(:,1,:), h, w, c);
        f_2 = reshape(f(:,2,:), h, w, c);
        
        % get backward difference
        grad_f1 = diff(f_1, 1, 2);   % x dir
        grad_f2 = diff(f_2, 1, 1);   % y dir
        
        % Neumann boundary condition
        div_f = padarray(grad_f1, [0, 1], 0, 'pre') + ...
            padarray(grad_f2, [1, 0], 0, 'pre');
        
        % output div_f is N x 1
        div_f = reshape(div_f, [], 1, c);
    else
        error('div: channel error')
    end
end

