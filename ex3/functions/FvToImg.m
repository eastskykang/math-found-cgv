function [ deformed_img ] = FvToImg( f_v_array, img )
    %FVTOIMG
    
    deformed_img = zeros(size(f_v_array, 1), size(f_v_array, 2), 3);
    
    for vx = 1:size(f_v_array, 2)
       for vy = 1:size(f_v_array, 1) 
           
           f_v = zeros(1, 2);
           f_v(1) = f_v_array(vy, vx, 1);
           f_v(2) = f_v_array(vy, vx, 2);
           
           if f_v(1) > 0 && f_v(2) > 0 && ...
                   f_v(1) < size(f_v_array, 2) && f_v(2) < size(f_v_array, 1)
               % check bound
               deformed_img(f_v(2), f_v(1), :) = img(vy, vx, :);
           end
       end
    end
    
    deformed_img = uint8(deformed_img);
end