%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK1'))
addpath('functions')
addpath('saved')

% data parameters
off_files = {'bun', 'bunny', 'bunny2', 'cat'};

sigma_array = {...
    0.01, 0.02, 0.03;   % bun
    0.01, 0.02, 0.03;   % bunny
    0.01, 0.02, 0.03;   % bunny2
    80, 90, 100         % cat
    };

% parameters
file_idx = 1;

sigma_r = 0.5;
sigma_n = 1.2;
iter = 5;

normal_mode = true;
ann_mode = true;

% debug
debug = false;

%% PART 1-3
disp('===================================================================')
disp('PART 1-3')

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
sigmas = sigma_array(file_idx, :);

if normal_mode
    disp('calculating new V matrix...')
    
    for i=1:size(sigmas, 2)
        
        sigma = sigmas{i};
        disp(['for sigma = ', num2str(sigma)])
        
        V = V_file;
        
        tic 
        for j=1:iter
            % calculate V_next: v_next = v - f(x) grad f(x)
            V_next = V - FxGradFx3D(V, V_file, N_file, sigma, debug);
            
            % V update
            V = V_next;
        end
        t = toc;
        
        % log running time
        disp(['NORMAL running time = ', num2str(t)])
        
        % saving file
        filename = [file, '_sig', num2str(sigma), '_it', num2str(iter), '.off'];
        disp(['off file saving: ', filename])
        
        N = per_vertex_normals(V,F_file);
        writeOFF(filename, V, F_file, [], [], N);
    end
end

%% CALCULATE NEW V WITH ANN 
% NOTE: randint function used in ANN wrapper is deprecated in 2016b version
%       change randint to randi for running.

if ann_mode
    disp('calculating new V matrix using ANN...')
    
    for i=1:size(sigmas, 2)
        
        sigma = sigmas{i};
        disp(['for sigma = ', num2str(sigma)])
        
        V = V_file;
        
        tic
        for j=1:iter
            % calculate V_next: v_next = v - f(x) grad f(x)
            V_next = V - FxGradFx3D_ANN(V, V_file, N_file, sigma, debug);
            
            % V update
            V = V_next;
        end
        t = toc;
        
        % log running time
        disp(['ANN running time = ', num2str(t)])
        
        % saving file
        filename = [file, '_sig', num2str(sigma), '_it', num2str(iter), '_ANN.off'];
        disp(['off file saving: ', filename])
        
        N = per_vertex_normals(V,F_file);
        writeOFF(filename, V, F_file, [], [], N);
    end
end

%% CALCULATE NEW V FOR RIMLS
% disp('calculating new V matrix using RIMLS...')
% 
% for i=1:size(sigmas, 2)
%     
%     sigma = sigmas{i};
%     disp(['for sigma = ', num2str(sigma)])
%     
%     V = V_file;
%     
%     for j=1:iter
%         % calculate V_next: v_next = v - f(x) grad f(x)
%         V_next = V - FxGradFx3D_RIMLS(V, V_file, N_file, sigma, sigma_r, sigma_n, 5, debug);
%         
%         % V update
%         V = V_next;
%     end
%     
%     filename = [file, '_sig', num2str(sigma), '_it', num2str(iter), '_RIMLS.off'];
%     
%     disp(['off file saving: ', filename])
%     
%     N = per_vertex_normals(V,F_file);
%     writeOFF(filename, V, F_file, [], [], N);
% end
