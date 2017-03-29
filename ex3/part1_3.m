%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK1'))
addpath('functions')
addpath('saved')

% parameters
off_files = {'bun', 'bunny', 'bunny2', 'cat'};

sigmas = {0.03};
iter = 5;

% debug
debug = true;

%% PART 1-3
disp('===================================================================')
disp('PART 1-3')

for file_idx = 1:size(off_files, 2)
    %% DATA LOAD
    file = off_files{file_idx};
    
    disp('-------------------------------------------------------------------')
    disp(['off file loading: ', file, '.off'])
    
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
        
        for j=1:iter
            % calculate V_next: v_next = v - f(x) grad f(x)
            V_next = V - FxGradFx3D(V, V_file, N_file, sigma, debug);
            
            % V update
            V = V_next;
        end

        filename = [file, '_sig', num2str(sigma), '_it', num2str(iter), '.off'];
        
        disp(['off file saving: ', filename])
        
        N = per_vertex_normals(V,F_file);
        writeOFF(filename, V, F_file, [], [], N);
    end
end