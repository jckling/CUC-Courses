%% PatchWork���
% ���룺Ƕ��ˮӡ��ͼ��·�����������������ѡȡ�����ظ���
% ���أ�ͳ��ֵ
function [res] = patch_extract(image_path, s, n)

marked_I = imread(image_path);
[I_x, I_y] = size(marked_I);

% α�����������
rng(s);
select = randperm(I_x*I_y, n*2);
[x, y]=ind2sub([I_x, I_y],select);    % ��������±�

res = 0;
for i=1:n
    res = sum(res+(double(marked_I(x(i), y(i)))-double(marked_I(x(i+n), y(i+n)))));
end

% res = round(res/n);

end