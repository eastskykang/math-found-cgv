function [ newProb ] = NewProblem( thetaLowerBound, thetaUpperBound )
    %NEWPROBLEM return new problem structure with input arguments
    
    if ~eq(size(thetaLowerBound), [1, 2])
        error('wrong argument for newProblem: thetaLowerBound');
    end
    
    if ~eq(size(thetaUpperBound), [1, 2])
        error('wrong argument for newProblem: thetaUpperBound');
    end
    
    if thetaLowerBound(1) >= thetaUpperBound(1) || ...
            thetaLowerBound(2) >= thetaUpperBound(2)
        error('wrong argument for newProblem: upper bound should be larger than lower bound');
    end
    
    newProb = struct(... 
    'ThetaLowerBound', thetaLowerBound, ...
    'ThetaUpperBound', thetaUpperBound, ...
    'ObjLowerBound', [], ...
    'ObjUpperBound', [], ...
    'ThetaOptimizer', []);
    
end

