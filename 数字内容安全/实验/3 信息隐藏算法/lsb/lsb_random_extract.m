%% 随机LSB提取
% 输入：掩密图像，随机数控制器，总数，位平面
% 返回：字符串，秘密信息矩阵
function [res_str, res_vector] = lsb_random_extract(img, s, n, f)
embed_I = img;
[I_x,I_y] = size(img);

% 随机选取的n个点
rng(s);
select = randperm(I_x*I_y, n);
[position_x, position_y]=ind2sub([I_x, I_y], select);

extract_watermark = uint8(zeros(n, 1));
for i = 1:n
    extract_watermark(i) = bitget(embed_I(position_x(i), position_y(i)), f);
end

res_str = vector2str(extract_watermark);    % 返回字符
res_vector = extract_watermark;             % 返回秘密信息
end