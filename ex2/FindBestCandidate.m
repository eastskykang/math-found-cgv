function [ best_pro, not_best_pro ] = FindBestCandidate( problems )
    %FINDBESTCANDIDATE 
    
    % problems: 2 prob
    if size(problems, 2) ~= 2
        error('Wrong argument: FindBestCandidate');
    end

    pro_1 = problems(1);
    pro_2 = problems(2);
    
    if pro_1.ObjUpperBound >= pro_2.ObjUpperBound
        best_pro = pro_1;
        not_best_pro = pro_2;
    else
        best_pro = pro_2;
        not_best_pro = pro_1;
    end
end

