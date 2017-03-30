%% EXERCISE X - PART X
clc
close all
clear all

% paths
addpath(genpath('files/TASK2'))
addpath('functions')
addpath('saved')

% parameters
grid_size_x = 100;
grid_size_y = 100;

alpha = 1;

saved_control_pts = true;   % false then user inputs control points

affine_T = true;
similar_T = true;
rigid_T = true;

forward_warp = true;    % show result of forward warping
backward_warp = true;   % show result of backward warping

% debug
debug = false;

%% DATA LOAD
disp('===================================================================')
disp('image loading...')

img = imread('ginger.png');

%% CONTROL POINT INPUT
disp('-------------------------------------------------------------------')
disp('load control points from pregenerated data or user input')

if saved_control_pts
    disp('load control points from pregenerated data.')
    
    load('saved/p_array.mat')
    load('saved/q_array.mat')
else
    disp('select control points and deformed position with mouse clicks. (at least 3 points)')

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
            if size(p, 1) < 3
                error('input at least three control points')
            end
            
            break;
        end
        
        plot(x, y, 'go', 'LineWidth',8)
        p = [p; [x, y]];
        
        disp(['deformed position(', num2str(i), ') : '])
        [x, y, ~] = ginput(1);
        
        plot(x, y, 'rx', 'LineWidth',8)
        q = [q; [x, y]];
        i = i + 1;
    end
    
    hold off
end

%% DEFORMATION
disp('-------------------------------------------------------------------')
disp('deformation...')

img_h = size(img, 1);
img_w = size(img, 2);

% affine deformation
if affine_T
    disp('affine deformation...')
    fa_v_array = AffineTransform(p, q, img_h, img_w, alpha);
    
    % forward warping
    disp('affine deformation: forward warping')
    img_aff_fw = FvToImg(fa_v_array, img);
    % backward warping
    disp('affine deformation: backward warping')
    img_aff_bw = BackwardWarp(fa_v_array, img);
end

% similarity deformation
if similar_T
    disp('similarity deformation...')
    fs_v_array = SimilarTransform(p, q, img_h, img_w, alpha);
    
    % forward warping
    disp('similarity deformation: forward warping')
    img_sim_fw = FvToImg(fa_v_array, img);
    % backward warping
    disp('similarity deformation: backward warping')
    img_sim_bw = BackwardWarp(fs_v_array, img);
end

% rigid deformation
if rigid_T
    disp('rigid deformation...')
    fr_v_array = RigidTransform(p, q, img_h, img_w, alpha);
    
    % forward warping
    disp('rigid deformation: forward warping')
    img_rig_fw = FvToImg(fr_v_array, img);
    % backward warping
    disp('rigid deformation: forward warping')
    img_rig_bw = BackwardWarp(fr_v_array, img);
end

%% VISUALIZATION
disp('-------------------------------------------------------------------')
disp('visualization...')

if forward_warp
    % forward warping
    disp('drawing result of forward warping...')

    figure(2)
    % original img
    subplot(2, 2, 1)
    imshow(img)
    title('Origimal image')
    hold on
    plot(p(:, 1), p(:, 2), 'go')
    plot(q(:, 1), q(:, 2), 'rx')
    hold off
    
    if affine_T
        % affine deformation        
        subplot(2, 2, 2)
        imshow(img_aff_fw)
        title(['Affine transform (forward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
    
    if similar_T
        % similarity deformation
        subplot(2, 2, 3)
        imshow(img_sim_fw)
        title(['Similarity transform (forward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
    
    if rigid_T
        % rigid deformation
        subplot(2, 2, 4)
        imshow(img_rig_fw)
        title(['Rigid transform (forward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
end

if backward_warp
    % backward warping
    disp('drawing result of backward warping...')
    
    figure(3)
    % original img
    subplot(2, 2, 1)
    imshow(img)
    title('Origimal image')
    hold on
    plot(p(:, 1), p(:, 2), 'go')
    plot(q(:, 1), q(:, 2), 'rx')
    hold off
    
    if affine_T
        % affine transform
        subplot(2, 2, 2)
        imshow(img_aff_bw)
        title(['Affine transform (backward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
    
    if similar_T
        % similarity deformation
        subplot(2, 2, 3)
        imshow(img_sim_bw)
        title(['Similarity transform (backward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
    
    if rigid_T
        % rigid deformation
        subplot(2, 2, 4)
        imshow(img_rig_bw)
        title(['Rigid transform (backward warping): alpha = ', num2str(alpha)])
        hold on
        plot(p(:, 1), p(:, 2), 'go')
        plot(q(:, 1), q(:, 2), 'rx')
        hold off
    end
end