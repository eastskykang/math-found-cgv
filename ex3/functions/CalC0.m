function [ C0 ] = CalC0( X_mat, Xi_mat, Ni, sigma, debug)
    %CALC0 calculate C0 and return it as a vector 
    
    % X_mat     n x d matrix    n is # of grid points, d is dimension
    % Xi_mat    m x d matrix    m is # of sample points, d is dimension 
    % Ni        m x d matrix    m is # of sample points, d is dimension 
    % C0        n x 1 vector    n is # of grid points
    
    C0 = zeros(size(X_mat, 1), 1);
    
    tic
    for idx = 1:size(X_mat, 1)
        % idx is index of grid point (x, y)
        
        X = X_mat(idx, :); % grid (x, y)
        
        % Ni: column j = (njx, njy)
        sqd_X_Xi = pdist2(X, Xi_mat, 'squaredeuclidean');   % column j = squared_euc_dist(x, xj)
        X_Xi = (X - Xi_mat)';                               % column j = (x - xj, y - yj)
        
        % phi_i(x) = exp(...)
        phi_i = exp(-sqd_X_Xi / (sigma^2));
        
        % sum(ni' * (X - Xi) * exp(...))
        nom = sum(dot(Ni', X_Xi) .* phi_i);
        % sum(exp(...))
        denom = sum(phi_i);
        
        C0(idx) = nom/denom;
    end
    
    t = toc;
    if debug
        disp(['iteration running time = ', num2str(t)])
    end
end

