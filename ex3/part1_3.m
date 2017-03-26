%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK1'))

% parameters
off_files = {'bun', 'cat'};

sigmas = {100};
iter = 5;

% debug
debug = false;

%% PART 1-3
disp('===================================================================')
disp('PART 1-3')

for file_idx = 1:size(off_files, 2)
    %% DATA LOAD
    file = off_files{file_idx};
    
    disp('-------------------------------------------------------------------')
    disp(['off file loading: ', file, '.off'])
    
    % TODO update readOFF file
    %  V  #V by 3 list of vertices
    %  F  #F by 3 list of triangle indices
    %  N  #V by 3 list of normals
    
    [V_file,F_file,~,~,~] = readOFF([file, '.off']);
    N_file = per_vertex_normals(V_file,F_file);
    
    %% CALCULATE NEW V
    disp('calculating new V matrix...')

    for i=1:size(sigmas, 2)
        
        sigma = sigmas{i}; 
        disp(['for sigma = ', num2str(sigma)])
        
        V = V_file;
        N = N_file;
        
        % X is initial V
        X = V;
        
        for j=1:iter
            % calculate V_next: v_next = v - f(x) grad f(x)
            V_next = V - FxGradFx3D(X, V, N, sigma, debug);
            
            % V update
            V = V_next;
        end

        filename = [file, '_sig', num2str(sigma), '_it', num2str(iter), '.off'];
        
        disp(['off file saving: ', filename])
        writeOFF(filename, V, F_file);
    end
end