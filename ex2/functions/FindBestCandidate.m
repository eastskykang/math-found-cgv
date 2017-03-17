function [ best_pro, not_best_pro ] = FindBestCandidate( problems )
    %FINDBESTCANDIDATE 
    
    % problems: 2 prob
    if size(problems, 2) ~= 2
        error('Wrong argument: FindBestCandidate');
    end

    pro_1 = problems(1);
    pro_2 = problems(2);
    
    if pro_1.ObjUpperBound > pro_2.ObjUpperBound
        % bigger upper bound -> best
        best_pro = pro_1;
        not_best_pro = pro_2;
    elseif pro_1.ObjUpperBound == pro_2.ObjUpperBound
        % upper bound is same 
        
        if pro_1.ObjLowerBound >= pro_2.ObjLowerBound
            % bigger (or equal) lower bound -> best
            best_pro = pro_1;
            not_best_pro = pro_2;
        else
            % bigger (or equal) lower bound -> best
            best_pro = pro_2;
            not_best_pro = pro_1;
        end
    else
        % bigger upper bound -> best
        best_pro = pro_2;
        not_best_pro = pro_1;
    end
end

