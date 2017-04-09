function [ r_max ] = Rmax( N, mode )
    %RMAX return r_max
    
    % parameters (DO NOT CHANGE)
    d = 2;  % dimension 
    
    % N is number of samples 
    if strcmp(mode, 'Gamito-Maddock')
        
        % max packing densities 
        % http://mathworld.wolfram.com/HyperspherePacking.html
        gamma_d_max = 1/6 * pi() * sqrt(3);      % for dimension n = 2
        
        % Gamito-Maddock
        % http://dl.acm.org/citation.cfm?id=1640451
        r_max = ((gamma_d_max / N) * (gamma(d/2 + 1) / pi()^(d/2)))^(1/d);        
    else
        error('wrong argument for Rmax mode')
    end
end

