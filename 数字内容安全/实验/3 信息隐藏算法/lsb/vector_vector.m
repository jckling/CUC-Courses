%% ����ü�/ƽ��
% ���룺����Ŀ���ȣ�Ŀ��߶�
% ���أ���С�仯��ľ���
function [res] = vector_vector(input_data, x, y)
[I_x, I_y] = size(input_data);
watermark = uint8(zeros(x, y));
for j = 1:y
    for k = 1:x
       watermark(j,k)=input_data(mod(j-1,I_x)+1,mod(k-1,I_y)+1);  % b = mod(a,m), a%m
    end
end
res = watermark;
end