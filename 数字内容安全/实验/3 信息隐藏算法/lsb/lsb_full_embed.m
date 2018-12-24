%% LSB嵌入
% 输入：原始载体图像，秘密信息矩阵，选择的位平面，和图像相同大小的秘密信息矩阵，保存的文件名
% 返回：嵌入秘密信息的图像
% 从(1,1)开始，之前的位平面嵌满，再嵌入目标位平面
function [res] = lsb_full_embed(img, watermark, n, full_watermark, name)

embed_I = img;

[M_x, M_y] = size(watermark);
[I_x, I_y] = size(full_watermark);

% 嵌满之前的位平面
for f=1:n-1
    for i=1:I_y
        for j=1:I_x
            embed_I(i,j)=bitset(embed_I(i,j), f, full_watermark(i,j));
        end
    end
end

% 嵌入目标位平面
for i=1:M_y
	for j=1:M_x
        embed_I(i,j)=bitset(embed_I(i,j), n, watermark(i,j));
	end
end

imwrite(embed_I, name);     % 写入文件
res = embed_I;              % 返回矩阵

end