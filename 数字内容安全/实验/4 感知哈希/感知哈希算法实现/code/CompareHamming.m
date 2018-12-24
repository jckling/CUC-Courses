%% 计算每一幅图像与原始图像的感知哈希的汉明距离
% OriginHashArray: Hash array of origin image
% ImgLst: Processed images
% Res: Hamming distance between origin image and every processed image
function [Res] = CompareHamming(ImgLst, HashArray)
    Res = zeros([1, length(ImgLst)]);
    for i=1:length(ImgLst)
        [Hash, Array] = PHash(ImgLst{i});
        Res(i) = Hamming(HashArray, Array);
%         if Res(i) < 0.05
%             figure();imshow(ImgLst{i});title(num2str(Res(i)))
%         end
    end
end