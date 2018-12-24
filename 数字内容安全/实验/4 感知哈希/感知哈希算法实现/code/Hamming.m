%% º∆À„∫∫√˜æ‡¿Î
% a: array1
% b: array2
% Disatnce: Hamming distance between a and b (must have same size)
function [Distance] = Hamming(a, b)

[x, y] = size(a);
Distance = double(length(find(a-b)~=0))/(x*y);
% Distance = length(find(a-b)~=0);

end