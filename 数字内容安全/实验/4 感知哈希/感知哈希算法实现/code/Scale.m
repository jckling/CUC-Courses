%% ͼ��ѹ��
% Img: Image array
% Strength: Quality factor �� [0,100]
% Res: Conpressed images
function [Res] = Scale(Img, Strength)
c = 1;
Res = {};

for i = Strength
    imwrite(Img, 'test.jpg', 'quality', i);
    Res{c} = imread('test.jpg');
    c = c + 1;
end

end