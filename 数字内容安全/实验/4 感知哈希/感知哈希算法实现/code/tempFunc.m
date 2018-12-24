function [Res] = tempFunc(aT, avg, DC)
    Res = DC.*((DC(1,1)/avg)^aT);
end