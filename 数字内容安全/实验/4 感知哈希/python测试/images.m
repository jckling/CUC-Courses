clc;
clear all;
close all;

% ��ȡͼ��
[I, map] = imread('lena512.bmp');
double_I = im2double(I);            % ����ת����uint8 �� double
info_I = size(I);                   % �ߣ�����������������������ͨ������ɫͼ��
dimension = ndims(I);               % ����ά��

% �Ҷȵ���
% I3 = ind2gray(I,map);             % ת��Ϊ�Ҷ�ͼ��
J = imadjust(I,[],[],0.5);          % ���ͼ���Ե
imwrite(J, 'grayscale_adjust.bmp');                 % jpeg imwrite(I, 'test.png', 'quality', q) % q��[0,100]

% ͼ��ѹ��
q = [1, 5, 10, 15, 30, 50, 70, 90];
for i = q
    imwrite(I, ['jpg_quality',int2str(i),'.jpg'], 'quality', i);    % q��[0,100]��Ĭ��75��Mode Ĭ��lossy����ѡlossless��BitDepthĬ��8
end

% ֱ��ͼ���⻯
equal_I = histeq(I);
imwrite(equal_I, 'equalization.bmp');

% ��˹����
g = imnoise(I, 'gaussian');             % imnoise(I, 'gaussian', m, var)��ֵm��Ĭ��0��������var��Ĭ��0.01��
imwrite(g, 'gaussian.bmp');
% ��˹�����ֹ�ʵ��
p3= 0;      % p3 mean
p4 = 0.05;  % p4 variance
manual_g = double_I + sqrt(p4)*randn(size(double_I)) + p3;
imwrite(manual_g,'gaussian_manual.bmp');
% ��������
s = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) �����ܶ�d��Ĭ��0.05�� 
imwrite(s, 'saltpepper.bmp');
% ���������ֹ�ʵ��
manual_s = double_I;
p3= 0.05;       % p3 = density
x = rand(size(manual_s));
d = find(x < p3/2);
manual_s(d) = 0; % Minimum value
d = find(x >= p3/2 & x < p3);
manual_s(d) = 255; % Maximum (saturated) value
imwrite(manual_s, 'saltpepper_manual.bmp');
% ��������
p = imnoise(I, 'poisson');
imwrite(p, 'poisson.bmp');

% �Լ��˸�˹������ͼ������˲�
x = medfilt2(g);                        % ��ֵ�˲�
imwrite(x, 'median_filter.bmp');

h = fspecial('average', 5);             % ��ֵ�˲�5x5ģ��
y = imfilter(g, h, 'replicate');        % �߽縴��
imwrite(y, 'mean_filter.bmp');

z = wiener2(g);                         % ����Ӧ�˲�
imwrite(z, 'adapt_filter.bmp');

% ͼ����ת
r = imrotate(I, 90);
imwrite(r, 'rotate_90.bmp');

% ͼ��Ŵ�/��С
bigger = imresize(I, 1.2);
smaller = imresize(I, 0.8);
imwrite(bigger, 'resize_1.2.bmp');
imwrite(smaller, 'resize_0.8.bmp');

% �ú��������ڵ�������/�Աȶȣ�٤��У��
J = imadjust(I);
imwrite(J, 'contrast.bmp');
