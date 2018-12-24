%% ��ʼ��
clc
clear all
close all

OriginImgPath = '../imgs/';
CompareImgPath = '../compare/';
SavePath = '../result/';

[Total, OriginImgLst] = FileName(OriginImgPath);

%% ͼ����
[WN, WNStrength] = deal([], [10, 15, 20, 25, 30, 35, 40]);                                  % ��˹������
[PN, PNStrength] = deal([], [0.01, 0.03, 0.05, 0.07, 0.10, 0.15, 0.20, 0.25, 0.30]);        % ��������
[AF, AFStrength] = deal([], [3, 5, 7, 9, 11, 13, 15]);                                      %  ��ֵ�˲�ģ��
[MF, MFStrength] = deal([], [3, 5, 7, 9, 11, 13, 15]);                                      % ��ֵ�˲�ģ��
[GS, GSStrength] = deal([], [0.1, 0.3, 0.5, 0.7, 0.9, 1.5, 2.0]);                           % ��˹�˲���׼��
[SC, SCStrength] = deal([], [1, 2, 10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90]);            % JPEGѹ����������

for i=1:Total
    
    OriginImg = imread(char(OriginImgLst(i)));
    if size(OriginImg, 3)==3
        OriginImg = rgb2gray(OriginImg);
    end
    [OriginHash, OriginHashArray] = PHash(OriginImg);
    
    ImgLst = WhiteNoise(OriginImg, WNStrength);
    WN = [WN; CompareHamming(ImgLst, OriginHashArray)];
    
    ImgLst = PepperNoise(OriginImg, PNStrength);
    PN = [PN; CompareHamming(ImgLst, OriginHashArray)];
    
    ImgLst = AvgFilter(OriginImg, AFStrength);
    AF = [AF; CompareHamming(ImgLst, OriginHashArray)];
    
    ImgLst = MedianFilter(OriginImg, MFStrength);
    MF = [MF; CompareHamming(ImgLst, OriginHashArray)];
    
    ImgLst = GaussianSmooth(OriginImg, GSStrength);
    GS = [GS; CompareHamming(ImgLst, OriginHashArray)];
    
    ImgLst = Scale(OriginImg, SCStrength);
    SC = [SC; CompareHamming(ImgLst, OriginHashArray)];
    
end

%% ��ͼ
f1=figure();
N=0;
DrawTogether(WNStrength, WN, 'Gaussian Noise', N);
N=N+length(WNStrength);
DrawTogether(PNStrength, PN, 'Pepper Noise', N);
N=N+length(PNStrength);
DrawTogether(AFStrength, AF, 'Average Filter', N);
N=N+length(AFStrength);
DrawTogether(MFStrength, MF, 'Median Filter', N);
N=N+length(MFStrength);
DrawTogether(GSStrength, GS, 'Gaussian Smooth', N);
N=N+length(GSStrength);
DrawTogether(SCStrength, SC, 'JPEG Downscale', N);
grid on;grid minor;
title('Multiple Operations');
xlabel('Different Operations');ylabel('Hamming Distance');
lgd = legend('boxoff', 'NumColumns',6);
hold off;
% saveas(f1, [SavePath,'result.pdf']);

%% ѡȡһ��ͼ��������ͼ��Ա�
CompareOthers = cell(Total-1);
t = randi(Total);j = 1;
SelectedImg = imread(char(OriginImgLst(t)));
figure();imshow(SelectedImg);
[SelectedHash, SelectedHashArray] = PHash(SelectedImg);
for i=1:Total
    if i~= t
        CompareOthers{j} = imread(char(OriginImgLst(i)));
        j = j+1;
    end
end
y = CompareHamming(CompareOthers, SelectedHashArray);
x = 1:Total-1;
f2 = figure();DrawTogether(x, y, '', 0);
title('Random Select One and Compare with Other Images');
xlabel('Other images');ylabel('Hamming Distance');
grid on;grid minor;
hold off;
% saveas(f2, [SavePath,'result_compare.pdf']);


%% ����ض�ͼ������޸�
OriginImg = imread('../imgs/lena.bmp');
[OriginHash, OriginHashArray] = PHash(OriginImg);
[T, ImgLst] = FileName('../compare/');
tempLst = cell(length(ImgLst));
for i=1:T
    tempLst{i} = imread(char(ImgLst(i)));
end
y = CompareHamming(tempLst, OriginHashArray);
x = 1:T;
f3 = figure();DrawTogether(x, y, '', 0);
title('Origin Image Compare with Content-Changed Image');
xlabel('Different Content-Changed Operation');ylabel('Hamming Distance');
grid on;grid minor;
% saveas(f3, [SavePath,'compare_result.pdf']);


