close all
clear all
clc

% ����ͼ��
img = '../imgs/lena.bmp';
I = imread(img);
[I_x, I_y] = size(I);
n = I_x*I_y;

% �ַ�������
watermark_path = '../watermark/a.txt';
fileID = fopen(watermark_path,'r');
formatSpec = '%s';
origin_watermark = fscanf(fileID,formatSpec);
fclose(fileID);
W = (-1).^double(str2vector(origin_watermark, 1, length(origin_watermark)*16)); % 0��1,1��-1

% % �������
% % ������ɢ�ֲ���α�������������
% len = 120;
% W = (-1).^(randi([0 1], [1, len])); 
% origin_watermark = '';

% ������
% Q1��1��ʼ��Q2��d��ʼ������Ϊdelta
d = 5;
delta = 3;
Q1 = 1:2*delta:n; % -1
Q2 = 1+d:2*delta:n; % 1

%% Ƕ��ˮӡ
% Ƶ����
D = dct2(I);
D = D(:);

% % ������
% D = I(:);

% Ƕ��ˮӡ
for i=1:length(W)
    if W(i)==-1
        D(i) = round((D(i)-1-d)/2/delta)*2*delta+d;
    else
        D(i) = round((D(i)-1-d-delta)/2/delta)*2*delta+d+delta+1;
    end
end

Y = reshape(D, [I_x, I_y]);
Y = idct2(Y)./255;      % Ƶ����

save_figure = figure();
subplot(1,2,1),imshow(I),title('ԭʼͼ��'),subplot(1,2,2),imshow(Y),title('Ƕ��ˮӡ��');
saveas(save_figure, 'QIMimg.png');
%% ��ȡˮӡ
% Ƶ����
rY = dct2(Y).*255;
rY = rY(:);

% % ������
% rY = double(Y(:));

% ��ȡˮӡ
res = zeros(1,length(W));
for i=1:length(W)
    b1 = norm(rY(i)-(round((rY(i)-1-d)/2/delta)*2*delta+d));                % pdistĬ��ŷ�Ͼ��� euclidean
    b2 = norm(rY(i)-(round((rY(i)-1-d-delta)/2/delta)*2*delta+d+delta+1));
    if b1 < b2
        res(i)=-1;
    else
        res(i)=1;
    end
end

% ������
res_str = vector2str(~uint8(res));
compare(I, W, origin_watermark, Y, res, res_str, '����ͼ��');

%% ͼ����
% ����������ļ�д��
[res_lst, res_name] = multi_handle(Y);
for j=1:length(res_lst)
    rY = double(res_lst{j}(:));
    res = zeros(1,length(W));
    for i=1:length(W)
        b1 = norm(rY(i)-(round((rY(i)-1-d)/2/delta)*2*delta+d));                % pdistĬ��ŷ�Ͼ��� euclidean
        b2 = norm(rY(i)-(round((rY(i)-1-d-delta)/2/delta)*2*delta+d+delta+1));
        if b1 < b2
            res(i)=-1;
        else
            res(i)=1;
        end
    end
    % ������
    res_str = vector2str(~uint8(res));
    compare(img, W, origin_watermark, Y, res, res_str, res_name{j});
end