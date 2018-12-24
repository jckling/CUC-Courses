%% 奇偶校验LSB嵌入
% 输入：载体图像，秘密信息字符串，重复次数，位平面，保存文件名
% 返回：随机数控制器，嵌入的总数
function [res] = slide_lsb_embed(img, watermark2, window_size, f, name)
n = size(watermark2,1)*size(watermark2,2);  % 水印大小
[I_x, I_y] = size(img);
embed_I = img;
num_x = fix(I_x/window_size);
num_y = fix(I_y/window_size);
count = 1;
watermark1 = watermark2(:);             % 二维 → 一维

% 选择位平面
for x = 1:num_x
    for y = 1:num_y
        % 判断当前区域内像素总和（mod2）是否和水印相等
        if mod(sum(sum(embed_I((x-1)*window_size+1:(x-1)*window_size+window_size, (y-1)*window_size+1:(y-1)*window_size+window_size))),2) ~= watermark1(count,1)
            for i = (x-1)*window_size+1:(x-1)*window_size+window_size
                for j = (y-1)*window_size+1:(y-1)*window_size+window_size
                    temp = bitget(embed_I(i, j), f);
                    embed_I(i, j) = bitset(embed_I(i, j), f, ~temp);    % 不相等则将区域内的所有像素的最低位取反
                end
            end
        end
        if count == n   % 水印嵌入完毕则跳出循环
            break;
        else
            count = count+1;
        end
    end
    if count == n       % 水印嵌入完毕则跳出循环
        break;
    end
end
    
imwrite(embed_I, name); % 写入文件
res = embed_I;          % 返回矩阵
end