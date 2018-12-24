%% LSB嵌入
% 输入：原始载体图像，秘密信息矩阵，选择的位平面，保存的文件名
% 返回：掩密图像
% 从(1,1)开始，在单独的一个位平面上嵌入
function [res] = lsb_embed(img, watermark, n, name)

embed_I = img;
[M_x, M_y] = size(watermark);

for i=1:M_y
	for j=1:M_x
        embed_I(i,j)=bitset(embed_I(i,j), n, watermark(i,j));
	end
end

imwrite(embed_I, name); % 写入文件
res = embed_I;          % 返回矩阵
end