%% LSB提取
% 输入：掩密图像，秘密信息宽度(未知输入0)，秘密信息高度(未知输入0)，嵌入的位平面
% 返回：字符串，秘密信息矩阵
function [res_str, res_vector] = lsb_extract(img, x, y, n)
I = img;
if x==0 && y ==0
    [I_x, I_y] = size(I);
else
    I_x = x;
    I_y = y;
end

extract_watermark = uint8(zeros(I_x,I_y));
for i=1:I_y
    for j=1:I_x
        extract_watermark(i,j)=bitget(I(i,j),n);
    end
end

res_str = vector2str(extract_watermark);    % 返回字符串
res_vector = extract_watermark;             % 返回矩阵
end