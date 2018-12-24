%% PatchWorkǶ��
% ���룺����·�������ظ�������ֵ��������ļ���
% ���أ��������������Ƕ��ˮӡ��ͼ��
function [s, res] = patch_embed(image_path, n, d, name)
I = imread(image_path);
[I_x, I_y] = size(I);
marked_I = I;

% α�����������
s = rng;
select = randperm(I_x*I_y, n*2);
[x,y]=ind2sub([I_x, I_y],select);    % ��������±�

% embed
for i=1:n
    if marked_I(x(i), y(i))+d > 255
        marked_I(x(i), y(i)) = 255;
    else
        marked_I(x(i), y(i)) = marked_I(x(i), y(i))+d;
    end
    if marked_I(x(i+n), y(i+n)) < 0
        marked_I(x(i+n), y(i+n)) = 0;
    else
        marked_I(x(i+n), y(i+n)) = marked_I(x(i+n), y(i+n))-d;
    end
end
save_figure = figure();
subplot(1,2,1),imshow(I),title('ԭʼͼ��'), subplot(1,2,2),imshow(marked_I), title('PatchWork�����');
saveas(save_figure,'PatchWork.png')
imwrite(marked_I, name);
res = marked_I;
end