%% PatchWork检测
% 输入：嵌入水印的图像路径，随机数控制器，选取的像素个数
% 返回：统计值
function [res] = patch_extract(image_path, s, n)

marked_I = imread(image_path);
[I_x, I_y] = size(marked_I);

% 伪随机数控制器
rng(s);
select = randperm(I_x*I_y, n*2);
[x, y]=ind2sub([I_x, I_y],select);    % 获得索引下标

res = 0;
for i=1:n
    res = sum(res+(double(marked_I(x(i), y(i)))-double(marked_I(x(i+n), y(i+n)))));
end

% res = round(res/n);

end