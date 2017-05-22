function [ grad_f ] = grad( f, I_size )
    %GRAD     
    
    % f is N x 1
    if size(I_size, 3) ~= 1
        error('grad function I_size wrong')
    end

    % size = h x w
    f = reshape(f, I_size);
    
    % get forward differences
    grad_f1 = diff(f, 1, 2);     % x dir
    grad_f2 = diff(f, 1, 1);     % y dir
    
    % Neumann boundary condition
    grad_f1 = padarray(grad_f1, [0, 1], 0, 'post');
    grad_f2 = padarray(grad_f2, [1, 0], 0, 'post');

    % output grad_f is N x 2
    grad_f = [grad_f1(:), grad_f2(:)];
end

