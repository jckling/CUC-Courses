%% ����תΪ�ַ���
% ���룺����
% ���أ��ַ���
% ����16λ��Ӣ��8λ������ͳһʹ��16λ��ʾ
function [res] = vector2str(input_data)

[x, y] = size(input_data);

temp = reshape(input_data.',1,[]);      % ��ά �� һά
temp = char(temp+'0');

temp_char = blanks(16);
res = blanks(rem(x*y, 16));             % ÿ16�����ر�ʾһ���ַ�
j = 1;
for i = 1:length(temp)
	temp_char(mod(i-1, 16)+1) = temp(i);
	if mod(i, 16) == 0
        res(j) = char(bin2dec(reshape(temp_char, 16, []).'));
        j = j + 1;
	end
end
end