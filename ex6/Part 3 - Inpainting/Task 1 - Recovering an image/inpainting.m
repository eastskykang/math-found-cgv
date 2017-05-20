clear all
close all
%% Initialize everything

Iorig = imread('oz2.jpg'); % Load the image
[h,w,c] = size(Iorig);

rng(0);
M = rand(h,w)>0.9; % Create a mask
I0 = uint8(repmat(M,1,1,3).*double(Iorig)); % Apply the mask to the image

figure(1)
subplot(1,2,1)
imshow(Iorig)
title('Original image')
subplot(1,2,2)
imshow(I0);


