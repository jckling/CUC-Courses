%% �ַ���ת����
% ���룺�ַ�����Ŀ������ȣ�Ŀ�����߶�
% ���أ�����
% ����16λ��Ӣ��8λ��ͳһʹ��16λ��ʾ
function [res] = str2vector(input_data, x, y)

binary = reshape(dec2bin(input_data, 16).'-'0',1,[]);   % �����Ʊ�ʾ
% char(bin2dec(reshape(char(binary+'0'), n, []).'));

res = uint8(zeros(x, y));
for i = 1:x
	for j = 1:y
        res(i, j) = binary(mod(((j-1)+(i-1)*y),(length(binary)))+1);
	end
end

% str = 'hello world!';
% dec2bin(str)
% out = num2cell(dec2bin(str),2)
% bin2dec(out)
% char(bin2dec(out).')
end