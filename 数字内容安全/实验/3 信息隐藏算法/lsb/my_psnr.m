%% 峰值信噪比
% 输入：图像1矩阵，图像2矩阵
% 返回：峰值信噪比
% mse - 均方差
% psnr - 峰值信噪比。值越大，表明失真越少
function [x] = my_psnr(image, marked_image)
total = numel(image);
A = double(image);
B = double(marked_image);
mse = sum(sum((A-B).^2))/total;
psnr = 10*log10(255^2/mse);    % 255为最大像素值
x = psnr;
end