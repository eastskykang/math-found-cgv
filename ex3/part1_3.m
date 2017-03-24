%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK1'))

% parameters

% debug
debug = false;

%% DATA LOAD
disp('===================================================================')
disp('PART 1-3')

disp('-------------------------------------------------------------------')
disp('data loading...')

% TODO update readOFF file
%  V  #V by 3 list of vertices
%  F  #F by 3 list of triangle indices
%  N  #V by 3 list of normals

sigma = 0.1;

[V,F,~,~,~] = readOFF('bun.off');
N = per_vertex_normals(V,F);

for idx = 1:size(F, 1)
    % idx is index of given point x = (x1, x2, x3) 
    
    X = F(idx, :);  % x = (x1, x2, x3) 

    % vertex point v = (v1, v2, v3)
    Ni = N';
    sqd_X_Xi = pdist2(X, V, 'squaredeuclidean');    % column j: squared_euc_dist(x, vj)
    X_Xi = (X - V)';                                % column j: (x1 - vj1, x2 - vj2)
    
    % phi_i(x) = exp(...)
    phi_i = exp(-sqd_X_Xi / (sigma^2));
    
    % grad_phi_i(x)
    grad_phi_i = (-2/sigma^2) * phi_i .* X_Xi;
    
    Ni .* phi_i + ...
        (dot(Ni, X_Xi) - ) .* gra_phi_i
        
end


