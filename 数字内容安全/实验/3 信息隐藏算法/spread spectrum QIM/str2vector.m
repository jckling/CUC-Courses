%% 字符串转矩阵
% 输入：字符串，目标矩阵宽度，目标矩阵高度
% 返回：矩阵
% 中文16位，英文8位，统一使用16位表示
function [res] = str2vector(input_data, x, y)

binary = reshape(dec2bin(input_data, 16).'-'0',1,[]);   % 二进制表示
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