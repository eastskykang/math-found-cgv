function [ f ] = f_I( hist_fg, hist_bg, I )
    %F_I
    
    % rgb channels
    I_r = I(:, :, 1);
    I_g = I(:, :, 2);
    I_b = I(:, :, 3);
    
    % resolution
    histRes = size(hist_fg, 1);
    
    % calculate f_i
    r_bin = idivide(I_r(:), (256 / histRes)) + 1;
    g_bin = idivide(I_g(:), (256 / histRes)) + 1;
    b_bin = idivide(I_b(:), (256 / histRes)) + 1;
    
    % change sub to ind
    idx = sub2ind(size(hist_fg), r_bin, g_bin, b_bin);
    
    f = log (hist_bg(idx) + 1e-10) - log (hist_fg(idx) + 1e-10);
end

