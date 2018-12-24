clc;
close all;
clear all;

%% Patchwork
path = '../imgs/lena.bmp';
name = 'patch_embed_image.bmp';
[s, res_img] = patch_embed(path, 10, 1, name);
res = patch_extract(name, s, 10);
process(name, s, 10);

%% 真随机数性质：①均值为0 ②相关性为0
% x1 = rng;
% x = rand(1,100);
% y1 = rng;
% y = rand(1,100);
% R2 = corr2(x,y);
% [R3, p] = corrcoef(x, y);         % 相关系数
% 
% sa = rng; 
% a = randi(I_x,[2, n]);          % 均匀离散分布的伪随机数（整数）
% 
% lst1 = rand(1, 100);            % 均匀分布的伪随机数 single/double
% lst2 = randn(1, 100);           % 标准正态分布的伪随机数 single/double
% lst3 = normrnd(0, 1, [1,5]);    % 正态分布 normrnd(mu,sigma) 均值mu 标准差sigma
% M_lst1 = mean(lst1);            % 均值
% M_lst2 = mean(lst2);
% M_lst3 = mean(lst3);
% C_lst1 = cov(lst1);             % 方差 标准差std
% C_lst2 = cov(lst2);
% C_lst3 = cov(lst3);
% [rho,pval] = corr(lst1,lst2);   % 线性相关，或其他相关
% R2 = corr2(lst1,lst2);          % 相关系数，互相关
% [R3, p] = corrcoef(lst1, lst2); % 线性相关系数，自相关，互相关
