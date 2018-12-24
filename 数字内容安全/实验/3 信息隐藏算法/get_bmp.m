%% 水印图像转化为灰度图像
% 输入：原始图像路径，保存的文件路径
function get_bmp(image_path, save_path)
    J = imread(image_path);
    J = imresize(J,[512, 512]);
    imwrite(rgb2gray(J), save_path);
end