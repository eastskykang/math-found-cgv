%% EXERCISE 3 - PART X
clc
% close all
clear all

% paths
addpath(genpath('files/TASK1'))
addpath('functions')
addpath('data')

% data parameters
off_files = {'bun', 'bunny', 'bunny2', 'cat'};

sigma_array = {...
    0.01, 0.02, 0.03;   % bun
    0.01, 0.02, 0.03;   % bunny
    0.01, 0.02, 0.03;   % bunny2
    80, 90, 100         % cat
    };

% parameters
max_iter = 10;
threshold = 1e-4;

% debug
debug = false;

%% PART 1-3
disp('===================================================================')
disp('PART 1-3')

for file_idx = 1:size(off_files, 2)
    sigmas = sigma_array(file_idx, :);  % do not change
    
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
        FxGradFx = zeros(size(V));
        
        tic
        for j=1:max_iter
            % calculate V_next: v_next = v - f(x) grad f(x)
            FxGradFx = FxGradFx3D(V, V_file, N_file, sigma, debug);
            
            % V update
            V = V - FxGradFx;
            
            if norm(FxGradFx) < threshold
                % converged
                break
            end
        end
        t = toc;
        
        % log running time
        disp(['NORMAL running time = ', num2str(t)])
        
        % saving file
        filename = [file, '_sig', num2str(sigma), '_it', num2str(max_iter), '.off'];
        disp(['off file saving: ', filename])
        
        N = per_vertex_normals(V,F_file);
        writeOFF(filename, V, F_file, [], [], N);
    end
end
