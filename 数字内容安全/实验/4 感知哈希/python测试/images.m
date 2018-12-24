clc;
clear all;
close all;

% 读取图像
[I, map] = imread('lena512.bmp');
double_I = im2double(I);            % 类型转换，uint8 → double
info_I = size(I);                   % 高（行数）、宽（列数）、像素通道（彩色图像）
dimension = ndims(I);               % 数组维数

% 灰度调整
% I3 = ind2gray(I,map);             % 转化为灰度图像
J = imadjust(I,[],[],0.5);          % 检测图像边缘
imwrite(J, 'grayscale_adjust.bmp');                 % jpeg imwrite(I, 'test.png', 'quality', q) % q∈[0,100]

% 图像压缩
q = [1, 5, 10, 15, 30, 50, 70, 90];
for i = q
    imwrite(I, ['jpg_quality',int2str(i),'.jpg'], 'quality', i);    % q∈[0,100]，默认75；Mode 默认lossy，可选lossless；BitDepth默认8
end

% 直方图均衡化
equal_I = histeq(I);
imwrite(equal_I, 'equalization.bmp');

% 高斯噪声
g = imnoise(I, 'gaussian');             % imnoise(I, 'gaussian', m, var)均值m（默认0），方差var（默认0.01）
imwrite(g, 'gaussian.bmp');
% 高斯噪声手工实现
p3= 0;      % p3 mean
p4 = 0.05;  % p4 variance
manual_g = double_I + sqrt(p4)*randn(size(double_I)) + p3;
imwrite(manual_g,'gaussian_manual.bmp');
% 椒盐噪声
s = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) 噪声密度d（默认0.05） 
imwrite(s, 'saltpepper.bmp');
% 椒盐噪声手工实现
manual_s = double_I;
p3= 0.05;       % p3 = density
x = rand(size(manual_s));
d = find(x < p3/2);
manual_s(d) = 0; % Minimum value
d = find(x >= p3/2 & x < p3);
manual_s(d) = 255; % Maximum (saturated) value
imwrite(manual_s, 'saltpepper_manual.bmp');
% 泊松噪声
p = imnoise(I, 'poisson');
imwrite(p, 'poisson.bmp');

% 对加了高斯噪声的图像进行滤波
x = medfilt2(g);                        % 中值滤波
imwrite(x, 'median_filter.bmp');

h = fspecial('average', 5);             % 均值滤波5x5模板
y = imfilter(g, h, 'replicate');        % 边界复制
imwrite(y, 'mean_filter.bmp');

z = wiener2(g);                         % 自适应滤波
imwrite(z, 'adapt_filter.bmp');

% 图像旋转
r = imrotate(I, 90);
imwrite(r, 'rotate_90.bmp');

% 图像放大/缩小
bigger = imresize(I, 1.2);
smaller = imresize(I, 0.8);
imwrite(bigger, 'resize_1.2.bmp');
imwrite(smaller, 'resize_0.8.bmp');

% 该函数可用于调整亮度/对比度，伽马校正
J = imadjust(I);
imwrite(J, 'contrast.bmp');
