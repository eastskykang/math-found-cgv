%% EXERCISE 6 - PART 3.1
clc
close all
clear all

% paths
addpath(genpath('Part 3 - Inpainting'))
addpath(genpath('functions'))

% parameters
% if these parameters are not set, algorithm runs with default values 
max_iter = 2000;

sigma = 1.5;
tau = 1.5;
lambda = 5;
theta = 1;

%% MAIN
% should be run with this script.

disp('===================================================================')
disp('PART 3-1')
inpainting;