%% 高斯平滑
% Img: Image array
% Strength: Standard deviation of the Gaussian distribution（标准差）
% Res: Images after gaussian smoothing
function [Res] = GaussianSmooth(Img, Strength)
c = 1;
Res = {};

for i = Strength
    Res{c} = imgaussfilt(Img, i);
    c = c+1;
end

end