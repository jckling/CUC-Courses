%% °×¸ßË¹ÔëÉù
% Img: Image array
% Strength: Signal-to-noise ratio in dB
% Res: Images with additive gaussian noise
function [Res] = WhiteNoise(Img, Strength)
DoubleImg = double(Img);
c = 1;
Res = {};

for i=Strength 
    Res{c} = uint8(awgn(DoubleImg, i));
    c = c+1;
end

end