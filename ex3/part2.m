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

% affine deformation
img_aff = uint8(AffineTransform(p, q, img, alpha));
img_sim = uint8(AffineTransform(p, q, img, alpha))

figure(2)
imshow(img_aff)