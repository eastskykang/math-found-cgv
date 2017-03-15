function [ ret, stack ] = PopFromStack( stack )
    %POPFROMSTACK 
    
    % stack is [1 n] size array
    if size(stack, 1) ~= 1
        error('Wrong argument: PopFromStack');
    end
    
    if size(stack, 2) <= 0
        error('Pop from empty stack');
    end
    
    top = size(stack, 2);
    ret = stack(top);
    
    stack(top) = [];
    
    if debug
        disp(ret)
        disp(stack)
    end
end

