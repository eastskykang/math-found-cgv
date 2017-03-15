function [ stack ] = PushToStack( stack, elem )
    %PUSHTOSTACK 
    
    % stack is [1 n] size array
    if size(stack, 1) ~= 1
        error('Wrong argument: PopFromStack');
    end
    
    stack = [stack, elem];
end

