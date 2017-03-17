function [ left_child ,right_child ] = SplitProblem( parent )
    %SPLITPROBLEM 
    
    % when branching, split the current space into two children subspaces
    % in half along the longest dimension
    
    Tx_ub = parent.ThetaUpperBound(1);
    Ty_ub = parent.ThetaUpperBound(2);
    Tx_lb = parent.ThetaLowerBound(1);
    Ty_lb = parent.ThetaLowerBound(2);
    
    x_range = Tx_ub - Tx_lb;
    y_range = Ty_ub - Ty_lb;
    
    if x_range > y_range
        % split x
        mid = Tx_lb + x_range/2;
        
        left_child = NewProblem([Tx_lb, Ty_lb], [floor(mid), Ty_ub]);
        right_child = NewProblem([ceil(mid), Ty_lb], [Tx_ub, Ty_ub]);
    else
        % split y
        mid = Ty_lb + y_range/2;
        
        left_child = NewProblem([Tx_lb, Ty_lb], [Tx_ub, floor(mid)]);
        right_child = NewProblem([Tx_lb, ceil(mid)], [Tx_ub, Ty_ub]);
    end
end

