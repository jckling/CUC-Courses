% �������ͼ�����X����һ�ײ�֣�info_I��ͼ��ĳ�����Ϣ
function [x, y] = MyDiff(info_I, X)     % һ�ײ�ֺ���
I = int8(X);
im_new = zeros(info_I);                 % ����������
im_new(info_I(1,1),:) = I(1,:) - I(info_I(1,1),:);
for i = 1:(info_I(1,1)-1)               % �������
    im_new(i,:) = I(i+1,:) - I(i,:);
end
im_new = im_new(:);
t = tabulate(im_new);                   % ͳ��
x = t(:,1);
y = t(:,2);
end