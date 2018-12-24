%% ��֪��ϣ
% Img: Image array
% Hash: Hex hash digest (string)
% HashArray: 10*64 0/1 array (uint8)
function [Hash, HashArray] = PHash(Img)
%% Ԥ����
% תΪ�Ҷ�ͼ��
if size(Img, 3)==3
    GrayImg = rgb2gray(Img);
else
    GrayImg = Img;
end

% ˫���β�ֵ bicubic interpolation 
ResizedImg = imresize(GrayImg, [64 64]);

% ��ֵ�˲� - ƽ��
h = fspecial('average', 3);
SmoothImg = imfilter(ResizedImg, h);

% ֱ��ͼ���⻯
EqImg = histeq(SmoothImg, 8);

%% ��ȡ��֪����
% 8*8�ֿ飬DCT�任
DoubleImg = im2double(EqImg);
T = dctmtx(8);  % N*N����
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(DoubleImg,[8 8],dct);

% ��ȡ��Ƶϵ��
mask = [1   1   1   0   0   0   0   0
        1   1   1   0   0   0   0   0
        1   1   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0
        0   0   0   0   0   0   0   0];
B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);

% Reconstruct the image using the two-dimensional inverse DCT of each block.
% invdct = @(block_struct) T' * block_struct.data * T;
% I2 = blockproc(B2,[8 8],invdct);
% figure();imshow(I2)

% �γɸ�֪����
temp = blockproc(B2,[8 8], @(block_struct) block_struct.data(:)');
PreFeature = zeros([64 64]);
for i=1:8
	PreFeature((i-1)*8+1:i*8,:) = reshape(temp(i,:),64,8)';
end


%% ���ദ��
% Waston�Ӿ�ģ�ͣ��Աȶȣ�
fun = @(block_struct) WatsonContrast(block_struct.data);
WatsonImg = blockproc(PreFeature, [8 8], fun);

% PCA���� 64*64 �� 10*64
PcaImg = pca(WatsonImg,'NumComponents',10)';

%% �����ϣֵ����ֵ����
R = 10;
PreHash = zeros([10 64]);
for i=1:64
	for j=1:10
        d = PcaImg(:,i);
        u = (d(R/2)+d(round((R+1)/2)))/2;
        if d(j) > u
            PreHash(j,i)=1;
        else
            PreHash(j,i)=0;
        end
	end
end

% ת��Ϊʮ������
PreHex = zeros([80 8]);
for i=1:10
	PreHex((i-1)*8+1:i*8,:) = reshape(PreHash(i,:),8,8)';
end
HexCell = binaryVectorToHex(PreHex)';
Hash = string(strjoin(HexCell, ''));

HashArray = uint8(PreHash);

end