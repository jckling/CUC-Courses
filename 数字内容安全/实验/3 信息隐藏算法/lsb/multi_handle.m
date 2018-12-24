%% ��ͼ����д���
% ���룺ͼ�����
% ���أ�ͼ��Ԫ������������Ԫ��
function [res_lst, res_name] = multi_handle(img)
I = img;

% ����
e1 = histeq(I);                          % histeq(I,n) ֱ��ͼ���⻯��Ĭ��64��ɢ�Ҷȼ� 
g1 = imnoise(I, 'gaussian');             % imnoise(I,'gaussian',m,var_gauss) ��ֵm��Ĭ��0�������� var_gauss��Ĭ��0.01��
g2 = imnoise(I, 'gaussian', 0.2);
s1 = imnoise(I, 'salt & pepper');        % imnoise(I, 'salt&pepper', d) �����ܶ�d��Ĭ��0.05��
s2 = imnoise(I, 'salt & pepper', 0.2);

% ����ֵ
res_lst = {e1, g1, g2, s1, s2};
res_name = {'ֱ��ͼ���⻯','��˹����0.01', '��˹����0.2', '��������0.05', '��������0.2'};
    
% �˲�
s = [3, 5, 11, 15, 23];                 % ģ���С
count = length(res_lst)+1;              % ����
for i = s
    x = medfilt2(I, [i, i]);            % ��ֵ�˲�
    h = fspecial('average', i);         % ��ֵ�˲�
    y = imfilter(I, h, 'replicate');    % �߽縴��
    res_lst{count} = x; 
    res_name{count}= [num2str(i), 'x', num2str(i), '��ֵ�˲�'];
    res_lst{count+1}=y;
    res_name{count+1}= [num2str(i), 'x', num2str(i), '��ֵ�˲�'];
    count = count+2;
end
g = imgaussfilt(I, 2);                  % ��˹�˲�����׼��2
res_lst{count} = g;
res_name{count} = '��˹�˲�2';
count = count+1;

% ͼ��ѹ��
q = [1, 10, 30, 50, 70, 90];    % ����Խ��ѹ����Խ��
for i = q
    imwrite(I, 'test.jpg', 'quality', i);    % q��[0,100]��Ĭ��75��Mode Ĭ��lossy����ѡlossless��BitDepthĬ��8
    res_lst{count} = imread('test.jpg');
    res_name{count} = ['����',int2str(i),'%ѹ��'];
    count = count + 1;
end

end