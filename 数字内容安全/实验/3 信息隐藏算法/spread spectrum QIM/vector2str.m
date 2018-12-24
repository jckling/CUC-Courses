%% 矩阵转为字符串
% 输入：矩阵
% 返回：字符串
% 中文16位，英文8位，这里统一使用16位表示
function [res] = vector2str(input_data)

[x, y] = size(input_data);

temp = reshape(input_data.',1,[]);      % 二维 → 一维
temp = char(temp+'0');

temp_char = blanks(16);
res = blanks(rem(x*y, 16));             % 每16个比特表示一个字符
j = 1;
for i = 1:length(temp)
	temp_char(mod(i-1, 16)+1) = temp(i);
	if mod(i, 16) == 0
        res(j) = char(bin2dec(reshape(temp_char, 16, []).'));
        j = j + 1;
	end
end
end