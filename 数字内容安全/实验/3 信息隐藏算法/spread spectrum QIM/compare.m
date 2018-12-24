%% 比较提取的秘密信息
% 输入：原始图像矩阵，原始图像提取的秘密信息矩阵，原始图像提取的字符串，经操作的图像矩阵，经操作的图像提取的秘密信息矩阵，经操作的图像提取的字符串
% 返回：正检率
function [diff_sum] = compare(img, origin_vector, origin_str, handled_img, handled_vector, handled_str, name)

% 统计不同的像素值
diff_sum =  1-double(length(find((origin_vector-handled_vector)~=0)))/(size(origin_vector, 1)*size(origin_vector, 2));

disp('原始秘密信息'), disp(origin_str);
disp([name,'提取的秘密信息']),disp(handled_str);
disp(['正确检出率: ', num2str(diff_sum)]);
fprintf('\n');
% figure,subplot(1,2,1),imshow(img),title('嵌入秘密信息的原始图像');subplot(1,2,2),imshow(handled_img),title(name);s

% 如果水印是一维序列，比较长就变换一下
if size(origin_vector, 1)==1 && size(origin_vector, 2)>100
    x = round(sqrt(length(origin_vector)));
    for i=x:-1:1
        if rem(length(origin_vector), i)==0
            y = length(origin_vector)/i;
            break
        end
    end
    origin_vector = reshape(origin_vector, [i, y]);
    handled_vector = reshape(handled_vector, [i, y]);
end

% 如果水印是图片
recover_origin_img = uint8(fix((double(origin_vector).*256)));
recover_handled_img = uint8(fix((double(handled_vector).*256)));
diff_img = imsubtract(recover_origin_img, recover_handled_img);
save_figure = figure();
subplot(1,3,1),imshow(recover_origin_img),title('原始秘密信息');
subplot(1,3,2),imshow( recover_handled_img);title([name,'提取信息']);
subplot(1,3,3),imshow(diff_img);title(['正确检出率: ', num2str(diff_sum)]);
saveas(save_figure, 'compare.png');
end