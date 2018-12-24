%% LSB��ȡ
% ���룺����ͼ��������Ϣ���(δ֪����0)��������Ϣ�߶�(δ֪����0)��Ƕ���λƽ��
% ���أ��ַ�����������Ϣ����
function [res_str, res_vector] = lsb_extract(img, x, y, n)
I = img;
if x==0 && y ==0
    [I_x, I_y] = size(I);
else
    I_x = x;
    I_y = y;
end

extract_watermark = uint8(zeros(I_x,I_y));
for i=1:I_y
    for j=1:I_x
        extract_watermark(i,j)=bitget(I(i,j),n);
    end
end

res_str = vector2str(extract_watermark);    % �����ַ���
res_vector = extract_watermark;             % ���ؾ���
end