clc;
clear all;
close all;

% 读取灰度图像
[I, map] = imread('lena512.bmp');
double_I = im2double(I);            % 类型转换，uint8 → double
info_I = size(I);                   % 高（行数）、宽（列数）、像素通道（彩色图像）
dimension = ndims(I);               % 数组维数
whos I;                             % 显示图像信息
imfinfo('lena512.bmp');             % 图像文件详细信息

% 显示图像
figure, subplot(1,2,1), imshow(I), title('原始图像');       % 默认256灰度级

% 显示一幅灰度图像的轮廓图
subplot(1,2,2), imcontour(I,3), title('图像轮廓');  % 轮廓级数

% 灰度调整
% I3 = ind2gray(I,map);             % 转化为灰度图像
J = imadjust(I,[],[],0.5);          % 检测图像边缘
figure, imshowpair(I, J, 'montage'), title('原始图像（左） 灰度调整（右）');

% 检测图像边缘
BW1 = edge(I,'sobel');              % sobel边缘算子
BW2 = edge(I,'canny');              % canny边缘算子
figure, imshowpair(BW1, BW2, 'montage'), title('边缘检测： sobel算子（左） canny算子（右）');

% 图像压缩
q = [1, 5, 10, 15, 30, 50, 70, 90];
num = 1;
figure;
for i = q
    imwrite(I, 'test.jpg', 'quality', i);    % q∈[0,100]，默认75；Mode 默认lossy，可选lossless；BitDepth默认8
    subplot(2, 4, num), imshow(imread('test.jpg')), title(['图像质量',int2str(i),'%'])  % 质量越低压缩率越大
    num = num + 1;
end

% 图像直方图
figure, subplot(1,2,1), imhist(I), title('原始图像直方图');

% 直方图均衡化
equal_I = histeq(I);
subplot(1,2,2), imhist(equal_I), title('直方图均衡化');

% 直方图规定化 % histeq(I, hspec); % hspec为指定的直方图

% 噪声
% 高斯噪声
g = imnoise(I, 'gaussian');             % imnoise(I, 'gaussian', m, var)均值m（默认0），方差var（默认0.01）
figure, subplot(2,3,1), imshow(I), title('原始图像');
subplot(2,3,2), imshow(g), title('高斯噪声');
% 高斯噪声手工实现
p3= 0;      % p3 mean
p4 = 0.01;  % p4 variance
manual_g = double_I + sqrt(p4)*randn(size(double_I)) + p3;
subplot(2,3,3), imshow(manual_g), title('手工高斯噪声');

% 椒盐噪声
s = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) 噪声密度d（默认0.05） 
subplot(2,3,4), imshow(s), title('椒盐噪声');
% 椒盐噪声手工实现
manual_s = double_I;
p3= 0.05;       % p3 = density
x = rand(size(manual_s));
d = find(x < p3/2);
manual_s(d) = 0; % Minimum value
d = find(x >= p3/2 & x < p3);
manual_s(d) = 255; % Maximum (saturated) value
subplot(2,3,5),imshow(manual_s), title('手工椒盐噪声');

% 泊松噪声
p = imnoise(I, 'poisson');
subplot(2,3,6), imshow(p), title('泊松噪声');
% 泊松噪声手工实现（暂无）

% 对加了高斯噪声的图像进行滤波
x = medfilt2(g);                        % 中值滤波
figure, subplot(2,5,1), imshow(g), title('高斯噪声图像');
subplot(2,5,2), imshow(x), title('中值滤波');

h = fspecial('average', 5);             % 均值滤波5x5模板
y = imfilter(g, h, 'replicate');        % 边界复制
subplot(2,5,3), imshow(y), title('5x5均值滤波'); 

h2 = fspecial('average', 11);             % 均值滤波11x11模板
y2 = imfilter(g, h2, 'replicate');        % 边界复制
subplot(2,5,4), imshow(y2), title('11x11均值滤波'); 

z = wiener2(g);                         % 自适应滤波
subplot(2,5,5), imshow(z), title('自适应滤波');

% 滤波前后灰度直方图
subplot(2,5,6), imhist(g), title('高斯噪声图像灰度直方图');
subplot(2,5,7), imhist(x), title('中值滤波灰度直方图');
subplot(2,5,8), imhist(y), title('5x5均值滤波灰度直方图');
subplot(2,5,9), imhist(y2), title('11x11均值滤波灰度直方图');
subplot(2,5,10), imhist(z), title('自适应滤波灰度直方图');

% 其他滤波
h = [1 2 1; 0 0 0; -1 -2 -1];           % 滤波模板
temp_I = filter2(h,I);                  % Y = filter2(H,X) 根据矩阵H中的系数，对数据矩阵X应用有限脉冲响应滤波器
figure, imshow(temp_I,[]), colorbar, title('自定义滤波');     % 添加颜色条，显示色阶的颜色栏

% 一阶差分图像 直方图
[xtick ,ytick] = MyDiff(info_I, I);
figure, bar(xtick, ytick, 'stacked'), title('原始图像一阶差分');

% 滤波前后图像的一阶差分直方图
[xtick ,ytick] = MyDiff(info_I, g);
figure, subplot(2,2,1), bar(xtick, ytick, 'stacked'), title('高斯噪声图像一阶差分');

[xtick ,ytick] = MyDiff(info_I, x);
subplot(2,2,2), bar(xtick, ytick, 'stacked'), title('中值滤波一阶差分');

[xtick ,ytick] = MyDiff(info_I, y);
subplot(2,2,3), bar(xtick, ytick, 'stacked'), title('5x5均值滤波一阶差分');

[xtick ,ytick] = MyDiff(info_I, z);
subplot(2,2,4), bar(xtick, ytick, 'stacked'), title('自适应滤波一阶差分');
