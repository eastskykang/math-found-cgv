clc
close all
clear all

% parameters
threshold = 3;  % 3 px

%% DATA LOAD
addpath('data');
load('data/ListInputPoints.mat', 'ListInputPoints');

% correspondences
p_left = ListInputPoints(:, 1:2);
p_right = ListInputPoints(:, 3:4);

n = size(p_left, 1);

% images
img_left = imread('data/InputLeftImage.png');
img_right = imread('data/InputRightImage.png');

[img_left_h, img_left_w, ~] = size(img_left);
[img_right_h, img_right_w, ~] = size(img_right);

% make P0 problem
P0 = NewProblem([-img_left_w, -img_left_h], [img_left_w, img_left_h]);

% solve P0 problem
[~, ~, ~] = SolveWithLP(p_left, p_right, P0, threshold);