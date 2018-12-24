%% ��ֵ�����
% ���룺ͼ��1����ͼ��2����
% ���أ���ֵ�����
% mse - ������
% psnr - ��ֵ����ȡ�ֵԽ�󣬱���ʧ��Խ��
function [x] = my_psnr(image, marked_image)
total = numel(image);
A = double(image);
B = double(marked_image);
mse = sum(sum((A-B).^2))/total;
psnr = 10*log10(255^2/mse);    % 255Ϊ�������ֵ
x = psnr;
end