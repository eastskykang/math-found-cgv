function pairWise = getPairWise(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get pairwise terms for each pairs of pixels on image I and for
% regularizer lambda.
%
% INPUT :
% - I      : color image
%
% OUTPUT :
% - pairwise : sparse square matrix containing the pairwise costs for image
%              I and parameter lambda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp('-------------------------------------------------------------------')
    disp('get pairwise cost...')
    tic

    % sizes
    [height, width, ~] = size(I);
    N = height * width;
    
    % sparse matrix
    i = [];
    j = [];
    v = [];
    
    for p = 1:N
        
        % vectorized for q!
        q_array = Neighbors(I, p);
        n = size(q_array, 1);
                                
        i = [i; p * ones(n, 1)];
        j = [j; q_array];
            
        v = [v; Bpq(I, p, q_array)];
        
    end
    
    pairWise = sparse(i, j, v, N, N);
    toc;
end

function Bpq = Bpq(I, p, q_array)
    % q_array is array of q (n x 1)
    
    I_r = I(:,:,1);
    I_g = I(:,:,2);
    I_b = I(:,:,3);
    
    % parameter
    sigma = 5;
    
    % p and q are linear index
    [p_row, p_col] = ind2sub(size(I_r), p);
    [q_rows, q_cols] = ind2sub(size(I_r), q_array);
    
    % Ip is 1 x 3 (rgb)
    Ip_r = double(I_r(p));
    Ip_g = double(I_g(p));
    Ip_b = double(I_b(p));
    
    Ip = [Ip_r, Ip_g, Ip_b];
    
    % Iq is n x 3 array (rgb)
    Iq_r = double(I_r(q_array));
    Iq_g = double(I_g(q_array));
    Iq_b = double(I_b(q_array));
    
    Iq = [Iq_r, Iq_g, Iq_b];
    
    Bpq = exp(- pdist2(Ip, Iq, 'squaredeuclidean') / 2 * sigma^2 ) ./ ...
        pdist2([p_row, p_col], [q_rows, q_cols], 'euclidean');
    
    % transpose
    Bpq = Bpq';
end


function q = Neighbors(I, p)
    
    [height, width, ~] = size(I);
    
    % p and q are linear index
    [p_row, p_col] = ind2sub(size(I(:,:,1)), p);
    
    q = [...
        p_row - 1, p_col - 1; ...
        p_row - 1, p_col; ...
        p_row - 1, p_col + 1; ...
        p_row, p_col - 1; ...
        p_row, p_col + 1; ...
        p_row + 1, p_col - 1; ...
        p_row + 1, p_col; ...
        p_row + 1, p_col + 1];
    
    q = q(q(:, 1) <= height & q(:, 2) <= width & ...
        q(:, 1) >= 1 & q(:, 2) >= 1, :);
    
    q = sub2ind([height, width], q(:,1), q(:,2));
end