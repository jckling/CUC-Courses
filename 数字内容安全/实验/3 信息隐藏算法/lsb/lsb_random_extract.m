%% ���LSB��ȡ
% ���룺����ͼ���������������������λƽ��
% ���أ��ַ�����������Ϣ����
function [res_str, res_vector] = lsb_random_extract(img, s, n, f)
embed_I = img;
[I_x,I_y] = size(img);

% ���ѡȡ��n����
rng(s);
select = randperm(I_x*I_y, n);
[position_x, position_y]=ind2sub([I_x, I_y], select);

extract_watermark = uint8(zeros(n, 1));
for i = 1:n
    extract_watermark(i) = bitget(embed_I(position_x(i), position_y(i)), f);
end

res_str = vector2str(extract_watermark);    % �����ַ�
res_vector = extract_watermark;             % ����������Ϣ
end