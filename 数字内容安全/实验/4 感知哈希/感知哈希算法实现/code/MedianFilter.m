%% ÖÐÖµÂË²¨
% Img: Image array
% Strength: Size of the filter
% Res: Images after median filtering
function [Res] = MedianFilter(Img, Strength)
c = 1;
Res = {};

for i = Strength          
    Res{c} = medfilt2(Img, [i, i]);
    c = c+1;
end

end