%% EXERCISE X - PART X
clc 
close all 
clear all 

% paths
addpath(genpath('files/TASK2'))
addpath('functions')
addpath('saved')

% parameters

% debug
debug = false;

%% DATA LOAD 
disp('===================================================================')
disp('image loading...')

img = imread('ginger.png');

% affine deformation 
v = [1, 1];  % image point  
p = [1, 1; 2, 1];  % selected control points (m x 2)
q = [1, 1; 2, 1];  % deformed control points (m x 2)

sqd_pi_v = pdist2(p, v, 'squaredeuclidean');    % ith row = norm(pi - v)^2 
w = 1 / (sqd_pi_v ^ alpha);                     % ith row = wi    

p_star = (w * p') / sum(w);
q_star = (w * q') / sum(w); 


Aj = 