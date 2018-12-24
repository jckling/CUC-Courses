%% 图像处理
% 输入：嵌入水印的图像路径，随机数控制器，像素个数
% 返回：无
function process(image_path, srng, n)
I = imread(image_path);

% 图像处理
e1 = histeq(I);                          % histeq(I,n) 直方图均衡化，默认64离散灰度级
g1 = imnoise(I, 'gaussian');             % imnoise(I,'gaussian',m,var_gauss) 均值m（默认0），方差 var_gauss（默认0.01）
g2 = imnoise(I, 'gaussian', 0.2);
s1 = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) 噪声密度d（默认0.05）
s2 = imnoise(I, 'salt & pepper', 0.2);
lst = {e1, g1, g2, s1, s2};
names = {'直方图均衡化', '高斯噪声（方差0.01）', '高斯噪声（方差0.2）', '椒盐噪声（密度0.05）', '椒盐噪声（密度0.2）'};
for i = 1:length(lst)
    imwrite(lst{i}, 'temp.bmp');
    res = patch_extract('temp.bmp', srng, n);
    name = [names{i}, ':  ', num2str(res)];
    figure(), imshow(lst{i}), title(name);
end

% 对图像进行滤波
s = [3, 5, 11, 15, 33];  % 模板大小
for i = s
    x = medfilt2(I, [i, i]);             % 中值滤波
    h = fspecial('average', i);                 % 均值滤波模板
    y = imfilter(I, h, 'replicate');% 边界复制
    
    imwrite(x, 'temp.bmp');
    res1 = patch_extract('temp.bmp', srng, n);
    name1 = ['中值滤波', num2str(i), 'x', num2str(i), ':  ', num2str(res1)];
    
    imwrite(y, 'temp.bmp');
    res2 = patch_extract( 'temp.bmp', srng, n);
    name2 = ['均值滤波', num2str(i), 'x', num2str(i), ':  ', num2str(res2)];
    
    figure(), subplot(1,2,1), imshow(x), title(name1), subplot(1,2,2), imshow(y), title(name2);
end
end