close all
clear all
clc

% 载体图像
img = '../imgs/lena.bmp';
I = imread(img);
[I_x, I_y] = size(I);
n = I_x*I_y;

% 字符串序列
watermark_path = '../watermark/a.txt';
fileID = fopen(watermark_path,'r');
formatSpec = '%s';
origin_watermark = fscanf(fileID,formatSpec);
fclose(fileID);
W = (-1).^double(str2vector(origin_watermark, 1, length(origin_watermark)*16)); % 0→1,1→-1

% % 随机序列
% % 均匀离散分布的伪随机数（整数）
% len = 120;
% W = (-1).^(randi([0 1], [1, len])); 
% origin_watermark = '';

% 量化器
% Q1从1开始，Q2从d开始，步长为delta
d = 5;
delta = 3;
Q1 = 1:2*delta:n; % -1
Q2 = 1+d:2*delta:n; % 1

%% 嵌入水印
% 频域处理
D = dct2(I);
D = D(:);

% % 空域处理
% D = I(:);

% 嵌入水印
for i=1:length(W)
    if W(i)==-1
        D(i) = round((D(i)-1-d)/2/delta)*2*delta+d;
    else
        D(i) = round((D(i)-1-d-delta)/2/delta)*2*delta+d+delta+1;
    end
end

Y = reshape(D, [I_x, I_y]);
Y = idct2(Y)./255;      % 频域处理

save_figure = figure();
subplot(1,2,1),imshow(I),title('原始图像'),subplot(1,2,2),imshow(Y),title('嵌入水印后');
saveas(save_figure, 'QIMimg.png');
%% 提取水印
% 频域处理
rY = dct2(Y).*255;
rY = rY(:);

% % 空域处理
% rY = double(Y(:));

% 提取水印
res = zeros(1,length(W));
for i=1:length(W)
    b1 = norm(rY(i)-(round((rY(i)-1-d)/2/delta)*2*delta+d));                % pdist默认欧氏距离 euclidean
    b2 = norm(rY(i)-(round((rY(i)-1-d-delta)/2/delta)*2*delta+d+delta+1));
    if b1 < b2
        res(i)=-1;
    else
        res(i)=1;
    end
end

% 正检率
res_str = vector2str(~uint8(res));
compare(I, W, origin_watermark, Y, res, res_str, '掩密图像');

%% 图像处理
% 不单独拆分文件写了
[res_lst, res_name] = multi_handle(Y);
for j=1:length(res_lst)
    rY = double(res_lst{j}(:));
    res = zeros(1,length(W));
    for i=1:length(W)
        b1 = norm(rY(i)-(round((rY(i)-1-d)/2/delta)*2*delta+d));                % pdist默认欧氏距离 euclidean
        b2 = norm(rY(i)-(round((rY(i)-1-d-delta)/2/delta)*2*delta+d+delta+1));
        if b1 < b2
            res(i)=-1;
        else
            res(i)=1;
        end
    end
    % 正检率
    res_str = vector2str(~uint8(res));
    compare(img, W, origin_watermark, Y, res, res_str, res_name{j});
end