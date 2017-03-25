%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK1'))

% parameters
iter = 5;

% debug
debug = false;
sigma = 100;

%% DATA LOAD
disp('===================================================================')
disp('PART 1-3')

disp('-------------------------------------------------------------------')
disp('data loading...')

% TODO update readOFF file
%  V  #V by 3 list of vertices
%  F  #F by 3 list of triangle indices
%  N  #V by 3 list of normals

[V,F,~,~,~] = readOFF('bun.off');
N = per_vertex_normals(V,F);
V_next = V;

for i=1:iter
    V_next = V - FxGradFx3D(V, V_next, N, sigma, debug);
end

writeOFF(filename, V_next,F)