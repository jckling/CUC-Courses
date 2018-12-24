close all
clear all
clc

% ����ͼ�񣬳���ΪN
img = '../imgs/lena.bmp';
I = imread(img);
[I_x, I_y] = size(I);
N = size(I,1)*size(I,2);

% ������Ϣ����W������ΪM
% �ַ�������
watermark_path = '../watermark/a.txt';
fileID = fopen(watermark_path,'r');
formatSpec = '%s';
origin_watermark = fscanf(fileID,formatSpec);
fclose(fileID);
W = (-1).^double(str2vector(origin_watermark, 1, length(origin_watermark)*16)); % 0��1,1��-1
M = length(W);

% % �������
% % ������ɢ�ֲ���α�������������
% M = 100;
% W = (-1).^(randi([0 1], [1, M]));
% origin_watermark = '';

% M������ΪN���������
sj = zeros(M, N);
for i=1:M
    sj(i,:) = (-1).^randi([0 1], N, 1);
end

% Ƕ��ǿ��
strength = 1;

%% Ƕ��������Ϣ
% Ƶ����
D = dct2(I);
X = D(:);

% % ������
% X = I(:);

% Ƕ��������Ϣ
for i=1:N
    temp = reshape(sj(:,i), [1, M]);
    X(i) = X(i)+strength*sum(temp.*W);
end

Y = reshape(X, [I_x, I_y]);
Y = idct2(Y)./255;      % Ƶ����
save_figure = figure();
subplot(1,2,1),imshow(I),title('ԭʼͼ��'),subplot(1,2,2),imshow(Y),title('Ƕ��������Ϣ��');
saveas(save_figure, 'img.png');
%% ��ȡ������Ϣ
% �������ϵ��
res = zeros(1,M);
for i=1:M
    temp = reshape(sj(i,:),[N,1]);
    [rho,pval] = corr(double(X), temp);     % R = corrcoef(X, sj(i,:)); R(1,2);����ǿ�������Ҫת��Ϊdouble
    if rho>0
        res(i)=1;
    else
        res(i)=-1;
    end
end

% ������
res_str = vector2str(~uint8(res));          % 1��0,-1��0��1
compare(I, W, origin_watermark, Y, res, res_str, '����ͼ��');
% 
%% ͼ����
% ����������ļ�д��
[res_lst, res_name] = multi_handle(Y);
for j=1:length(res_lst)
    X = double(res_lst{j}(:));
    res = zeros(1,M);
    for i=1:M
        temp = reshape(sj(i,:),[N,1]);
        [rho,pval] = corr(double(X), temp);     % R = corrcoef(X, sj(i,:)); R(1,2);����ǿ�������Ҫת��Ϊdouble
        if rho>0
            res(i)=1;
        else
            res(i)=-1;
        end
    end
    % ������
    res_str = vector2str(~uint8(res));
    compare(img, W, origin_watermark, Y, res, res_str, res_name{j});
end
