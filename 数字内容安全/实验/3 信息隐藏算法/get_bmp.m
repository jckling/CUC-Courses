%% ˮӡͼ��ת��Ϊ�Ҷ�ͼ��
% ���룺ԭʼͼ��·����������ļ�·��
function get_bmp(image_path, save_path)
    J = imread(image_path);
    J = imresize(J,[512, 512]);
    imwrite(rgb2gray(J), save_path);
end