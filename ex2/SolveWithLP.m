function [ prob ] = SolveWithLP( p_left, p_right, prob, thres )
    %SOLVEWITHLP
    
    % x = [T_x, T_y, z1, ..., zn, w1x, ..., wnx, w1y, ..., wny]
    n = size(p_left, 1);
    
    % threshold
    
    % A_i_1 =
    %   0 0 | 0 ... ( xi - xi' - thres) ... 0 | 0 ...  1 ... 0 | 0 ...  0 ... 0
    %   0 0 | 0 ... (-xi + xi' - thres) ... 0 | 0 ... -1 ... 0 | 0 ...  0 ... 0
    %   0 0 | 0 ... ( yi - yi' - thres) ... 0 | 0 ...  0 ... 0 | 0 ...  1 ... 0
    %   0 0 | 0 ... (-yi + yi' - thres) ... 0 | 0 ...  0 ... 0 | 0 ... -1 ... 0
    
    % b_i_1 = [0 0 0 0]'
    
    x_xd_delta = p_left(:, 1) - p_right(:, 1) - thres;
    y_yd_delta = p_left(:, 2) - p_right(:, 2) - thres;
    
    xd_x_delta = -p_left(:, 1) + p_right(:, 1) - thres;
    yd_y_delta = -p_left(:, 2) + p_right(:, 2) - thres;
    
    A1 = [...
        zeros(n, 2), diag(x_xd_delta), eye(n), zeros(n);
        zeros(n, 2), diag(xd_x_delta), -eye(n), zeros(n);
        zeros(n, 2), diag(y_yd_delta), zeros(n), eye(n);
        zeros(n, 2), diag(yd_y_delta), zeros(n), -eye(n)];
    
    b1 = zeros(4 * n, 1);
    
    % bilinear constraints
    
    % zi * Tx >= max( zi_ * Tx + Tx_ * zi - zi_ * Tx_, ^zi * Tx + ^Tx * zi - ^zi * ^Tx)
    % zi * Tx <= max( ^zi * Tx + Tx_ * zi - ^zi * Tx_, zi_ * Tx + ^Tx * zi - zi_ * ^Tx)
    % zi * Ty >= max( zi_ * Ty + Ty_ * zi - zi_ * Ty_, ^zi * Ty + ^Ty * zi - ^zi * ^Ty)
    % zi * Ty <= max( ^zi * Ty + Ty_ * zi - ^zi * Ty_, zi_ * Ty + ^Ty * zi - zi_ * ^Ty)
    
    Tx_lb = prob.ThetaLowerBound(1);
    Ty_lb = prob.ThetaLowerBound(2);
    Tx_ub = prob.ThetaUpperBound(1);
    Ty_ub = prob.ThetaUpperBound(2);
    
    A2 = [...
        zeros(n, 2),                    Tx_lb * eye(n),     -eye(n),    zeros(n);
        ones(n, 1),     zeros(n, 1),    Tx_ub * eye(n),     -eye(n),    zeros(n);
        -ones(n, 1),    zeros(n, 1),    -Tx_lb * eye(n),    eye(n),     zeros(n);
        zeros(n, 2),                    -Tx_ub * eye(n),    eye(n),     zeros(n)];
    
    b2 = [zeros(n, 1); Tx_ub * ones(n, 1); -Tx_lb * ones(n, 1); zeros(n, 1)];
    
    A3 = [...
        zeros(n, 2),                    Ty_lb * eye(n),     zeros(n),   -eye(n);
        zeros(n, 1),    ones(n, 1),     Ty_ub * eye(n),     zeros(n),   -eye(n);
        zeros(n, 1),    -ones(n, 1),    -Ty_lb * eye(n),    zeros(n),   eye(n);
        zeros(n, 2),                    -Ty_ub * eye(n),    zeros(n),   eye(n)];
    
    b3 = [zeros(n, 1); Ty_ub * ones(n, 1); -Ty_lb * ones(n, 1); zeros(n, 1)];
    
    % linprog
    A = [A1; A2; A3];
    b = [b1; b2; b3];
    
    % f = [0; 0; -1; -1; ..., -1; 0; 0; ... 0; 0]
    f = [0; 0; -ones(n, 1); zeros(2*n, 1)];
    
    % lb = [Tx_lb; Ty_lb; 0 ... 0; no const for w]
    lb = [Tx_lb; Ty_lb; zeros(n, 1); -inf(2*n, 1)];
    % ub = [Tx_ub; Ty_ub; 1 ... 1; no const for w]
    ub = [Tx_ub; Ty_ub; ones(n, 1); inf(2*n, 1)];
    
    % min f'x
    % s.t. Ax <= b
    %      lb <= x <= ub
    [x, cost] = linprog(f, A, b, [], [], lb, ub);
    
    T_x = x(1);
    T_y = x(2);
    cost = - cost;
    
    % problem update
    n_inlier_ub = cost;
    n_inlier_lb = ComputeInlierLb(p_left, p_right, T_x, T_y, thres);
    
    prob.ThetaOptimizer = [T_x, T_y];
    prob.ObjLowerBound = n_inlier_lb;
    prob.ObjUpperBound = n_inlier_ub;
end

