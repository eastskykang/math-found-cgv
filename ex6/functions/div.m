function [ div_f ] = div( f, I_size )
    %DIV 
    
    % f is N x 2
    if size(I_size, 3) ~= 1
        error('div function I_size wrong')
    end

    % size(f) = h x w
    f_1 = reshape(f(:,1), I_size);
    f_2 = reshape(f(:,2), I_size);
    
    % get backward difference
    grad_f1 = diff(f_1, 1, 2);   % x dir
    grad_f2 = diff(f_2, 1, 1);   % y dir
    
    % Neumann boundary condition
    div_f = padarray(grad_f1, [0, 1], 0, 'pre') + ...
        padarray(grad_f2, [1, 0], 0, 'pre');
    
    % output div_f is N x 1
    div_f = div_f(:);
end

