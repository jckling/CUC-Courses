%% 矩阵裁剪/平铺
% 输入：矩阵，目标宽度，目标高度
% 返回：大小变化后的矩阵
function [res] = vector_vector(input_data, x, y)
[I_x, I_y] = size(input_data);
watermark = uint8(zeros(x, y));
for j = 1:y
    for k = 1:x
       watermark(j,k)=input_data(mod(j-1,I_x)+1,mod(k-1,I_y)+1);  % b = mod(a,m), a%m
    end
end
res = watermark;
end