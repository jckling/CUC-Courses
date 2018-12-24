clc;
clear all;
close all;

% ��ȡ�Ҷ�ͼ��
[I, map] = imread('lena512.bmp');
double_I = im2double(I);            % ����ת����uint8 �� double
info_I = size(I);                   % �ߣ�����������������������ͨ������ɫͼ��
dimension = ndims(I);               % ����ά��
whos I;                             % ��ʾͼ����Ϣ
imfinfo('lena512.bmp');             % ͼ���ļ���ϸ��Ϣ

% ��ʾͼ��
figure, subplot(1,2,1), imshow(I), title('ԭʼͼ��');       % Ĭ��256�Ҷȼ�

% ��ʾһ���Ҷ�ͼ�������ͼ
subplot(1,2,2), imcontour(I,3), title('ͼ������');  % ��������

% �Ҷȵ���
% I3 = ind2gray(I,map);             % ת��Ϊ�Ҷ�ͼ��
J = imadjust(I,[],[],0.5);          % ���ͼ���Ե
figure, imshowpair(I, J, 'montage'), title('ԭʼͼ���� �Ҷȵ������ң�');

% ���ͼ���Ե
BW1 = edge(I,'sobel');              % sobel��Ե����
BW2 = edge(I,'canny');              % canny��Ե����
figure, imshowpair(BW1, BW2, 'montage'), title('��Ե��⣺ sobel���ӣ��� canny���ӣ��ң�');

% ͼ��ѹ��
q = [1, 5, 10, 15, 30, 50, 70, 90];
num = 1;
figure;
for i = q
    imwrite(I, 'test.jpg', 'quality', i);    % q��[0,100]��Ĭ��75��Mode Ĭ��lossy����ѡlossless��BitDepthĬ��8
    subplot(2, 4, num), imshow(imread('test.jpg')), title(['ͼ������',int2str(i),'%'])  % ����Խ��ѹ����Խ��
    num = num + 1;
end

% ͼ��ֱ��ͼ
figure, subplot(1,2,1), imhist(I), title('ԭʼͼ��ֱ��ͼ');

% ֱ��ͼ���⻯
equal_I = histeq(I);
subplot(1,2,2), imhist(equal_I), title('ֱ��ͼ���⻯');

% ֱ��ͼ�涨�� % histeq(I, hspec); % hspecΪָ����ֱ��ͼ

% ����
% ��˹����
g = imnoise(I, 'gaussian');             % imnoise(I, 'gaussian', m, var)��ֵm��Ĭ��0��������var��Ĭ��0.01��
figure, subplot(2,3,1), imshow(I), title('ԭʼͼ��');
subplot(2,3,2), imshow(g), title('��˹����');
% ��˹�����ֹ�ʵ��
p3= 0;      % p3 mean
p4 = 0.01;  % p4 variance
manual_g = double_I + sqrt(p4)*randn(size(double_I)) + p3;
subplot(2,3,3), imshow(manual_g), title('�ֹ���˹����');

% ��������
s = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) �����ܶ�d��Ĭ��0.05�� 
subplot(2,3,4), imshow(s), title('��������');
% ���������ֹ�ʵ��
manual_s = double_I;
p3= 0.05;       % p3 = density
x = rand(size(manual_s));
d = find(x < p3/2);
manual_s(d) = 0; % Minimum value
d = find(x >= p3/2 & x < p3);
manual_s(d) = 255; % Maximum (saturated) value
subplot(2,3,5),imshow(manual_s), title('�ֹ���������');

% ��������
p = imnoise(I, 'poisson');
subplot(2,3,6), imshow(p), title('��������');
% ���������ֹ�ʵ�֣����ޣ�

% �Լ��˸�˹������ͼ������˲�
x = medfilt2(g);                        % ��ֵ�˲�
figure, subplot(2,5,1), imshow(g), title('��˹����ͼ��');
subplot(2,5,2), imshow(x), title('��ֵ�˲�');

h = fspecial('average', 5);             % ��ֵ�˲�5x5ģ��
y = imfilter(g, h, 'replicate');        % �߽縴��
subplot(2,5,3), imshow(y), title('5x5��ֵ�˲�'); 

h2 = fspecial('average', 11);             % ��ֵ�˲�11x11ģ��
y2 = imfilter(g, h2, 'replicate');        % �߽縴��
subplot(2,5,4), imshow(y2), title('11x11��ֵ�˲�'); 

z = wiener2(g);                         % ����Ӧ�˲�
subplot(2,5,5), imshow(z), title('����Ӧ�˲�');

% �˲�ǰ��Ҷ�ֱ��ͼ
subplot(2,5,6), imhist(g), title('��˹����ͼ��Ҷ�ֱ��ͼ');
subplot(2,5,7), imhist(x), title('��ֵ�˲��Ҷ�ֱ��ͼ');
subplot(2,5,8), imhist(y), title('5x5��ֵ�˲��Ҷ�ֱ��ͼ');
subplot(2,5,9), imhist(y2), title('11x11��ֵ�˲��Ҷ�ֱ��ͼ');
subplot(2,5,10), imhist(z), title('����Ӧ�˲��Ҷ�ֱ��ͼ');

% �����˲�
h = [1 2 1; 0 0 0; -1 -2 -1];           % �˲�ģ��
temp_I = filter2(h,I);                  % Y = filter2(H,X) ���ݾ���H�е�ϵ���������ݾ���XӦ������������Ӧ�˲���
figure, imshow(temp_I,[]), colorbar, title('�Զ����˲�');     % �����ɫ������ʾɫ�׵���ɫ��

% һ�ײ��ͼ�� ֱ��ͼ
[xtick ,ytick] = MyDiff(info_I, I);
figure, bar(xtick, ytick, 'stacked'), title('ԭʼͼ��һ�ײ��');

% �˲�ǰ��ͼ���һ�ײ��ֱ��ͼ
[xtick ,ytick] = MyDiff(info_I, g);
figure, subplot(2,2,1), bar(xtick, ytick, 'stacked'), title('��˹����ͼ��һ�ײ��');

[xtick ,ytick] = MyDiff(info_I, x);
subplot(2,2,2), bar(xtick, ytick, 'stacked'), title('��ֵ�˲�һ�ײ��');

[xtick ,ytick] = MyDiff(info_I, y);
subplot(2,2,3), bar(xtick, ytick, 'stacked'), title('5x5��ֵ�˲�һ�ײ��');

[xtick ,ytick] = MyDiff(info_I, z);
subplot(2,2,4), bar(xtick, ytick, 'stacked'), title('����Ӧ�˲�һ�ײ��');
