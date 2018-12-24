% 对输入的图像矩阵X进行一阶差分，info_I是图像的长宽信息
function [x, y] = MyDiff(info_I, X)     % 一阶差分函数
I = int8(X);
im_new = zeros(info_I);                 % 创建空数组
im_new(info_I(1,1),:) = I(1,:) - I(info_I(1,1),:);
for i = 1:(info_I(1,1)-1)               % 逐行相减
    im_new(i,:) = I(i+1,:) - I(i,:);
end
im_new = im_new(:);
t = tabulate(im_new);                   % 统计
x = t(:,1);
y = t(:,2);
end