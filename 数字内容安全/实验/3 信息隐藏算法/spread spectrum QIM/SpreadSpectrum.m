close all
clear all
clc

% 载体图像，长度为N
img = '../imgs/lena.bmp';
I = imread(img);
[I_x, I_y] = size(I);
N = size(I,1)*size(I,2);

% 秘密信息序列W，长度为M
% 字符串序列
watermark_path = '../watermark/a.txt';
fileID = fopen(watermark_path,'r');
formatSpec = '%s';
origin_watermark = fscanf(fileID,formatSpec);
fclose(fileID);
W = (-1).^double(str2vector(origin_watermark, 1, length(origin_watermark)*16)); % 0→1,1→-1
M = length(W);

% % 随机序列
% % 均匀离散分布的伪随机数（整数）
% M = 100;
% W = (-1).^(randi([0 1], [1, M]));
% origin_watermark = '';

% M个长度为N的随机序列
sj = zeros(M, N);
for i=1:M
    sj(i,:) = (-1).^randi([0 1], N, 1);
end

% 嵌入强度
strength = 1;

%% 嵌入秘密信息
% 频域处理
D = dct2(I);
X = D(:);

% % 空域处理
% X = I(:);

% 嵌入秘密信息
for i=1:N
    temp = reshape(sj(:,i), [1, M]);
    X(i) = X(i)+strength*sum(temp.*W);
end

Y = reshape(X, [I_x, I_y]);
Y = idct2(Y)./255;      % 频域处理
save_figure = figure();
subplot(1,2,1),imshow(I),title('原始图像'),subplot(1,2,2),imshow(Y),title('嵌入秘密信息后');
saveas(save_figure, 'img.png');
%% 提取秘密信息
% 计算相关系数
res = zeros(1,M);
for i=1:M
    temp = reshape(sj(i,:),[N,1]);
    [rho,pval] = corr(double(X), temp);     % R = corrcoef(X, sj(i,:)); R(1,2);如果是空域处理需要转化为double
    if rho>0
        res(i)=1;
    else
        res(i)=-1;
    end
end

% 正检率
res_str = vector2str(~uint8(res));          % 1→0,-1→0→1
compare(I, W, origin_watermark, Y, res, res_str, '掩密图像');
% 
%% 图像处理
% 不单独拆分文件写了
[res_lst, res_name] = multi_handle(Y);
for j=1:length(res_lst)
    X = double(res_lst{j}(:));
    res = zeros(1,M);
    for i=1:M
        temp = reshape(sj(i,:),[N,1]);
        [rho,pval] = corr(double(X), temp);     % R = corrcoef(X, sj(i,:)); R(1,2);如果是空域处理需要转化为double
        if rho>0
            res(i)=1;
        else
            res(i)=-1;
        end
    end
    % 正检率
    res_str = vector2str(~uint8(res));
    compare(img, W, origin_watermark, Y, res, res_str, res_name{j});
end
