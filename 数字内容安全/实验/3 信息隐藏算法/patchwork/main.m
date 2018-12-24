clc;
close all;
clear all;

%% Patchwork
path = '../imgs/lena.bmp';
name = 'patch_embed_image.bmp';
[s, res_img] = patch_embed(path, 10, 1, name);
res = patch_extract(name, s, 10);
process(name, s, 10);

%% ����������ʣ��پ�ֵΪ0 �������Ϊ0
% x1 = rng;
% x = rand(1,100);
% y1 = rng;
% y = rand(1,100);
% R2 = corr2(x,y);
% [R3, p] = corrcoef(x, y);         % ���ϵ��
% 
% sa = rng; 
% a = randi(I_x,[2, n]);          % ������ɢ�ֲ���α�������������
% 
% lst1 = rand(1, 100);            % ���ȷֲ���α����� single/double
% lst2 = randn(1, 100);           % ��׼��̬�ֲ���α����� single/double
% lst3 = normrnd(0, 1, [1,5]);    % ��̬�ֲ� normrnd(mu,sigma) ��ֵmu ��׼��sigma
% M_lst1 = mean(lst1);            % ��ֵ
% M_lst2 = mean(lst2);
% M_lst3 = mean(lst3);
% C_lst1 = cov(lst1);             % ���� ��׼��std
% C_lst2 = cov(lst2);
% C_lst3 = cov(lst3);
% [rho,pval] = corr(lst1,lst2);   % ������أ����������
% R2 = corr2(lst1,lst2);          % ���ϵ���������
% [R3, p] = corrcoef(lst1, lst2); % �������ϵ��������أ������
