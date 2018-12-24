%% LSB匹配嵌入
% 输入：原始载体图像，秘密信息矩阵，保存的文件名
% 输出：随机序列种子，掩密图像1，掩密图像2
function [s, res1, res2] = lsb_match_embed(img, watermark, name)
embed_I1 = img;
embed_I2 = img;
[I_x, I_y] = size(img);
[M_x, M_y] = size(watermark);
n = M_x*M_y;

% 利用随机序列进行±1
select = (-1).^randi([0 1], n, 1);

% 从(1,1)开始嵌入
count = 1;
for i=1:M_y
	for j=1:M_x
        if bitget(embed_I1(i,j),1) ~= watermark(i,j)
            if embed_I1(i,j)==0
                embed_I1(i,j) = embed_I1(i,j)+1;
            elseif embed_I1(i,j)==255
                embed_I1(i,j) = embed_I1(i,j)-1;
            else
                embed_I1(i,j) = embed_I1(i,j)+select(count);
            end
            count = count+1;
        end
	end
end

% 随机嵌入
if n>I_x*I_y    % 载体图像
    disp('秘密信息数量过大');
    pause;
end
    

% 水印一维化
watermark1 = watermark(:);      % 二维 → 一维
% 随机位置
s = rng;
pos = randperm(I_x*I_y, n);
[x, y]=ind2sub([I_x, I_y], pos);    % 获得索引下标
count = 1;
for i=1:n
	if bitget(embed_I2(x(i),y(i)),1) ~= watermark1(i)
        if embed_I2(x(i),y(i))==0
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))+1;
        elseif embed_I2(x(i),y(i))==255
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))-1;
        else
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))+select(count);
        end
	count = count+1;
    end
end


imwrite(embed_I1, name);    % 写入文件
imwrite(embed_I2, name);    % 写入文件
res1 = embed_I1;            % 返回矩阵1
res2 = embed_I2;            % 返回矩阵2
end