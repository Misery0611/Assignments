clc;
clear;
close;
% Load and convert to grayscale image
noisy_img = imread('noisy_img.png');
noisy_img = rgb2gray(noisy_img);

% Filter using Median filter
median_img = medfilt2(noisy_img);
% Filter using Mean filter
mean_kernel = ones(3, 3) / 9;
mean_img = imfilter(noisy_img, mean_kernel);

% Plot
subplot(1, 3, 1);
imshow(noisy_img);
title('Noisy image');

subplot(1, 3, 2);
imshow(median_img);
title('Median filter');

subplot(1, 3, 3);
imshow(mean_img);
title('Mean filter');