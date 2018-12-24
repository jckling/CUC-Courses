%% 读取每个文件的路径
% Path: Where images stored
% Total: Number of images
% Res: Image path with name
function [Total, Res] = FileName(Path)
    
    PngImg = dir([Path '*.png']);
    BmpImg = dir([Path '*.bmp']);
    JpgImg = dir([Path '*.jpg']);
    
    Total = length(PngImg)+length(BmpImg)+length(JpgImg);
    Res = strings(1,Total);
    c = 1;
    
    if length(PngImg) ~= 0
        for i=1:length(PngImg)
            Res(c) = [Path PngImg(i).name];
            c = c+1;
        end
    end
    
    
    if length(BmpImg) ~= 0
        for i=1:length(BmpImg)
            Res(c) = [Path BmpImg(i).name];
            c = c+1;
        end
    end
    
    
    if length(JpgImg) ~= 0
        for i=1:length(JpgImg)
            Res(c) = [Path JpgImg(i).name];
            c = c+1;
        end
    end
    
end