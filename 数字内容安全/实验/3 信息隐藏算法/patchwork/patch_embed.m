%% PatchWork嵌入
% 输入：载体路径，像素个数，±值，保存的文件名
% 返回：随机数控制器，嵌入水印的图像
function [s, res] = patch_embed(image_path, n, d, name)
I = imread(image_path);
[I_x, I_y] = size(I);
marked_I = I;

% 伪随机数控制器
s = rng;
select = randperm(I_x*I_y, n*2);
[x,y]=ind2sub([I_x, I_y],select);    % 获得索引下标

% embed
for i=1:n
    if marked_I(x(i), y(i))+d > 255
        marked_I(x(i), y(i)) = 255;
    else
        marked_I(x(i), y(i)) = marked_I(x(i), y(i))+d;
    end
    if marked_I(x(i+n), y(i+n)) < 0
        marked_I(x(i+n), y(i+n)) = 0;
    else
        marked_I(x(i+n), y(i+n)) = marked_I(x(i+n), y(i+n))-d;
    end
end
save_figure = figure();
subplot(1,2,1),imshow(I),title('原始图像'), subplot(1,2,2),imshow(marked_I), title('PatchWork处理后');
saveas(save_figure,'PatchWork.png')
imwrite(marked_I, name);
res = marked_I;
end