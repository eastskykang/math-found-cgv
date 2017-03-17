function [ opt_history ] = SaveOptHistory( opt_history, P, new_opt, debug )
    %SAVEOPTHISTORY function to save optimal solution history for each
    %iteration step
    
    if debug
        if size(opt_history, 2) ~= 4
            error('wrong argument for SaveOptHistory: opt_history size is not proper');
        end
        
        % n x 4 size
        opt_history = ...
            [   opt_history;
                new_opt, [P.ObjUpperBound, P.ObjLowerBound] ];
    else
        if size(opt_history, 2) ~= 2
            error('wrong argument for SaveOptHistory: opt_history size is not proper');
        end
        
        % n x 2 size
        opt_history = [ opt_history; new_opt];
    end
end

