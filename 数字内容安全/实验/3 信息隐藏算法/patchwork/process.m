%% ͼ����
% ���룺Ƕ��ˮӡ��ͼ��·��������������������ظ���
% ���أ���
function process(image_path, srng, n)
I = imread(image_path);

% ͼ����
e1 = histeq(I);                          % histeq(I,n) ֱ��ͼ���⻯��Ĭ��64��ɢ�Ҷȼ�
g1 = imnoise(I, 'gaussian');             % imnoise(I,'gaussian',m,var_gauss) ��ֵm��Ĭ��0�������� var_gauss��Ĭ��0.01��
g2 = imnoise(I, 'gaussian', 0.2);
s1 = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) �����ܶ�d��Ĭ��0.05��
s2 = imnoise(I, 'salt & pepper', 0.2);
lst = {e1, g1, g2, s1, s2};
names = {'ֱ��ͼ���⻯', '��˹����������0.01��', '��˹����������0.2��', '�����������ܶ�0.05��', '�����������ܶ�0.2��'};
for i = 1:length(lst)
    imwrite(lst{i}, 'temp.bmp');
    res = patch_extract('temp.bmp', srng, n);
    name = [names{i}, ':  ', num2str(res)];
    figure(), imshow(lst{i}), title(name);
end

% ��ͼ������˲�
s = [3, 5, 11, 15, 33];  % ģ���С
for i = s
    x = medfilt2(I, [i, i]);             % ��ֵ�˲�
    h = fspecial('average', i);                 % ��ֵ�˲�ģ��
    y = imfilter(I, h, 'replicate');% �߽縴��
    
    imwrite(x, 'temp.bmp');
    res1 = patch_extract('temp.bmp', srng, n);
    name1 = ['��ֵ�˲�', num2str(i), 'x', num2str(i), ':  ', num2str(res1)];
    
    imwrite(y, 'temp.bmp');
    res2 = patch_extract( 'temp.bmp', srng, n);
    name2 = ['��ֵ�˲�', num2str(i), 'x', num2str(i), ':  ', num2str(res2)];
    
    figure(), subplot(1,2,1), imshow(x), title(name1), subplot(1,2,2), imshow(y), title(name2);
end
end