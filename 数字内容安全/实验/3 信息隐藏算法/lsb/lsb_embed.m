%% LSBǶ��
% ���룺ԭʼ����ͼ��������Ϣ����ѡ���λƽ�棬������ļ���
% ���أ�����ͼ��
% ��(1,1)��ʼ���ڵ�����һ��λƽ����Ƕ��
function [res] = lsb_embed(img, watermark, n, name)

embed_I = img;
[M_x, M_y] = size(watermark);

for i=1:M_y
	for j=1:M_x
        embed_I(i,j)=bitset(embed_I(i,j), n, watermark(i,j));
	end
end

imwrite(embed_I, name); % д���ļ�
res = embed_I;          % ���ؾ���
end