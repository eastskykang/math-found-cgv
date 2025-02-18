function [ C0 ] = Fx2D( xi, yi, nix, niy, x_range, y_range, sigma, debug )
    %FX2D calculate F(x) = C0(x) for 2D point x
    
    [x_gr, y_gr] = meshgrid(x_range, y_range);
    
    X_mat = [x_gr(:), y_gr(:)]; % row is vector x (grid point)
    Xi_mat =[xi(:), yi(:)];     % row is vector x_j (jth sample)
    Ni = [nix(:), niy(:)];      % row is vector n_j (njx, njy)
    
    C0 = CalC0(X_mat, Xi_mat, Ni, sigma, debug);
    
    % C0 
    % (-2, -2) | (2, -2)
    % (-2, 2)  | (2, 2)
    C0 = reshape(C0, size(y_range, 2), size(x_range, 2));
end

