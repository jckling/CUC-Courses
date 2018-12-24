%% ½·ÑÎÔëÉù
% Img: Image array
% Strength: Noise density
% Res: Images with pepper&salt noise
function [Res] = PepperNoise(Img, Strength)
c = 1;
Res = {};

for i=Strength
    Res{c} = imnoise(Img, 'salt & pepper', i);
    c = c+1;
end

end