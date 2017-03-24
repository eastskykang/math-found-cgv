function [ output_args ] = Fx3D( F, V, N, sigma, debug )
    %FX3D calculate F(x) = C0(x) for 3D point x
    
    % F     n x 3 matrix    grid points 
    % V     m x 3 matrix    vertex points (samples) 
    % N     m x 3 matrix    normal vectors (samples)
    
    C0 = CalC0(F, V, N, sigma, debug);
    
end

