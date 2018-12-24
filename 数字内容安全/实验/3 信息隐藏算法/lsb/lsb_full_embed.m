%% LSBǶ��
% ���룺ԭʼ����ͼ��������Ϣ����ѡ���λƽ�棬��ͼ����ͬ��С��������Ϣ���󣬱�����ļ���
% ���أ�Ƕ��������Ϣ��ͼ��
% ��(1,1)��ʼ��֮ǰ��λƽ��Ƕ������Ƕ��Ŀ��λƽ��
function [res] = lsb_full_embed(img, watermark, n, full_watermark, name)

embed_I = img;

[M_x, M_y] = size(watermark);
[I_x, I_y] = size(full_watermark);

% Ƕ��֮ǰ��λƽ��
for f=1:n-1
    for i=1:I_y
        for j=1:I_x
            embed_I(i,j)=bitset(embed_I(i,j), f, full_watermark(i,j));
        end
    end
end

% Ƕ��Ŀ��λƽ��
for i=1:M_y
	for j=1:M_x
        embed_I(i,j)=bitset(embed_I(i,j), n, watermark(i,j));
	end
end

imwrite(embed_I, name);     % д���ļ�
res = embed_I;              % ���ؾ���

end