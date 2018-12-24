%% 对图像进行处理
% 输入：图像矩阵
% 返回：图像元胞，操作名称元胞
function [res_lst, res_name] = multi_handle(img)
I = img;

% 处理
e1 = histeq(I);                          % histeq(I,n) 直方图均衡化，默认64离散灰度级 
g1 = imnoise(I, 'gaussian');             % imnoise(I,'gaussian',m,var_gauss) 均值m（默认0），方差 var_gauss（默认0.01）
g2 = imnoise(I, 'gaussian', 0.2);
s1 = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) 噪声密度d（默认0.05）
s2 = imnoise(I, 'salt & pepper', 0.2);

% 返回值
res_lst = {e1, g1, g2, s1, s2};
res_name = {'直方图均衡化','高斯噪声0.01', '高斯噪声0.2', '椒盐噪声0.05', '椒盐噪声0.2'};
    
% 滤波
s = [3, 5, 11, 15, 23];                 % 模板大小
count = length(res_lst)+1;              % 计数
for i = s
    x = medfilt2(I, [i, i]);            % 中值滤波
    h = fspecial('average', i);         % 均值滤波
    y = imfilter(I, h, 'replicate');    % 边界复制
    res_lst{count} = x; 
    res_name{count}= [num2str(i), 'x', num2str(i), '中值滤波'];
    res_lst{count+1}=y;
    res_name{count+1}= [num2str(i), 'x', num2str(i), '均值滤波'];
    count = count+2;
end
g = imgaussfilt(I, 2);                  % 高斯滤波，标准差2
res_lst{count} = g;
res_name{count} = '高斯滤波2';
count = count+1;

% 图像压缩
q = [1, 10, 30, 50, 70, 90];    % 质量越低压缩率越大
for i = q
    imwrite(I, 'test.jpg', 'quality', i);    % q∈[0,100]，默认75；Mode 默认lossy，可选lossless；BitDepth默认8
    res_lst{count} = imread('test.jpg');
    res_name{count} = ['质量',int2str(i),'%压缩'];
    count = count + 1;
end

end