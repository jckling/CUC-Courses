%% 均值滤波
% Img: Image array
% Strength: Size of the filter
% Res: Images after average filtering
function [Res] = AvgFilter(Img, Strength)
c = 1;
Res = {};

for i = Strength
    h = fspecial('average', i);
    Res{c} = imfilter(Img, h, 'replicate');    % 边界复制
    c = c+1;
end

end