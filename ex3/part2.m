%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK2'))
addpath('functions')
addpath('saved')

% parameters
alpha = 1;

affine_T = true;
similar_T = true;
rigid_T = true;

% debug
debug = true;

%% DATA LOAD
disp('===================================================================')
disp('image loading...')

img = imread('ginger.png');

%% CONTROL POINT INPUT
disp('-------------------------------------------------------------------')
disp('select control points and deformed position with mouse clicks. ')

if debug
    load('saved/p_array.mat')
    load('saved/q_array.mat')
else
    figure(1)
    imshow(img)
    hold on
    
    p = zeros(0, 2);
    q = zeros(0, 2);
    i = 1;
    
    while true
        disp(['control point(', num2str(i), ') : (press space bar to exit)'])
        
        [x, y, button] = ginput(1);
        
        if button == 32
            % escape loop space bar
            break;
        end
        
        plot(x, y, 'bo')
        p = [p; [x, y]];
        
        disp(['deformed position(', num2str(i), ') : '])
        [x, y, ~] = ginput(1);
        
        plot(x, y, 'go')
        q = [q; [x, y]];
        i = i + 1;
    end
    
    hold off
end

%% DEFORMATION
% affine deformation
if affine_T
    img_aff = uint8(AffineTransform(p, q, img, alpha));
end

% similarity deformation
if similar_T
    img_sim = uint8(SimilarTransform(p, q, img, alpha));
end

% rigid deformation
if rigid_T
    img_rig = uint8(RigidTransform(p, q, img, alpha));
end

%% VISUALIZATION
figure(2)
if affine_T
    subplot(1, 3, 1)
    imshow(img_aff)
end

if similar_T
    subplot(1, 3, 2)
    imshow(img_sim)
end

if rigid_T
    subplot(1, 3, 3)
    imshow(img_rig)
end