%% EXERCISE X - PART X
clc
% close all
clear all

% paths
addpath(genpath('files/TASK1'))
addpath('functions')
addpath('saved')

addpath([matlabroot, '/toolbox/ann_wrapper'])   % change to ann_wrapper path

% data parameters
off_files = {'bun', 'bunny', 'bunny2', 'cat'};

% parameters
file_idx = 4;

max_iter = 5;
threshold = 1e-4;

rimls_mode = true;

% rimls parameters
hs = {100};
sigma_r = 0.5;  % parameter for RIMLS (DO NOT CHANGE!)
sigma_n = 0.5;  % parameter for RIMLS (sharpness)

% debug
debug = false;

%% PART 1-5
disp('===================================================================')
disp('PART 1-5')

%% DATA LOAD
file = off_files{file_idx};

disp('-------------------------------------------------------------------')
disp(['off file loading: ', file, '.off'])

%  V  #V by 3 list of vertices
%  F  #F by 3 list of triangle indices
%  N  #V by 3 list of normals

[V_file,F_file,~,~,~] = readOFF([file, '.off']);
N_file = per_vertex_normals(V_file,F_file);


%% CALCULATE NEW V FOR RIMLS
disp('calculating new V matrix using RIMLS...')

for i=1:size(hs, 2)
    h = hs{i};
    disp(['for h = ', num2str(h)])
    
    V = V_file;
    
    V = FxGradFx3D_RIMLS(V, V_file, N_file, h, sigma_r, sigma_n, max_iter, debug);
    filename = [file, '_h', num2str(h), '_it', num2str(max_iter), '_RIMLS.off'];
    
    disp(['off file saving: ', filename])
    
    N = per_vertex_normals(V,F_file);
    writeOFF(filename, V, F_file, [], [], N);
end
