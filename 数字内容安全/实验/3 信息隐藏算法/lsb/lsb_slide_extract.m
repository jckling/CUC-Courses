%% 奇偶校验LSB提取
% 输入：掩密图像，窗口大小，总数，位平面
% 返回：字符串，秘密信息矩阵
function [res_str, res_vector] = lsb_slide_extract(img, window_size, n)
embed_I = img;
[I_x,I_y] = size(img);
if mod(window_size,2) ~= 1
    disp('窗口大小要为奇数');
    pause;
elseif fix(I_x/window_size) * fix(I_y/window_size) < n
    disp('窗口太大，无法提取全部水印');
    pause;
else
    num_x = fix(I_x/window_size);
    num_y = fix(I_y/window_size);
    extract_watermark = uint8(zeros(n, 1));
    count = 1;
    for x = 1:num_x
        for y = 1:num_y
            extract_watermark(count) =  mod(sum(sum(embed_I((x-1)*window_size+1:(x-1)*window_size+window_size, (y-1)*window_size+1:(y-1)*window_size+window_size))),2);
            if count == n       % 秘密信息提取完毕则跳出循环
                break;
            else
                count = count +1;
            end
        end
        if count == n           % 秘密信息提取完毕则跳出循环
                break;
        end
    end
    res_str = vector2str(extract_watermark);    % 返回字符
    res_vector = extract_watermark;             % 返回矩阵
end
end