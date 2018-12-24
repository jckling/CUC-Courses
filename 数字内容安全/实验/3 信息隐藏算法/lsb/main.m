clc
% clear all
close all

%% 图像载体
img = '../imgs/peppers.bmp';
path = 'result/peppers/';  % 结果保存路径
I = imread(img);
[I_x,I_y] = size(I);


%% 秘密信息
% % 图片信息
% origin_watermark = imread('../watermark/cuc.bmp');
% [J_x, J_y] = size(origin_watermark);
% full_watermark = vector_vector(origin_watermark, I_x, I_y);

% % 字符串信息
% watermark_path = 'a.txt';
% fileID = fopen(watermark_path,'r');
% formatSpec = '%s';
% origin_watermark = fscanf(fileID,formatSpec);
% fclose(fileID);
% full_watermark = str2vector(origin_watermark, I_x, I_y);

% 随机信息
s = rng; 
origin_watermark = uint8(randi([0 1], [10, 10]));      % 均匀离散分布的伪随机数（整数）
full_watermark = vector_vector(origin_watermark, I_x, I_y);

%% LSB
% 待嵌信息大小
size_scale = [0.2, 0.5, 0.6, 0.8, 1.0];

% 记录信息
record_size = uint8(length(size_scale)*8);
xtick = zeros(1, record_size);                                  % 记录容量
my_peaksnr = zeros(1, record_size);                             % 记录PSNR（调用my_psnr）
peaksnr = zeros(1, record_size); snr = zeros(1, record_size);   % 记录psnr、snr（调用MATLAB自带函数）
ssimval = zeros(1, record_size);                                % 记录SSIM（结构相似性）
time_spend = double(zeros(1, record_size));                     % 记录经过的时间

for f=1:8
	for i=1:length(size_scale)
        % 计数
        num = (f-1)*length(size_scale)+i;
        
        % 统计时间
        start_time=cputime;
        
        x = round(size_scale(i)*I_x);
        y = round(size_scale(i)*I_y);
%         watermark = str2vector(origin_watermark, x, y); % 字符
        watermark = vector_vector(origin_watermark, x, y);    % 二进制流（图像/随机序列）
        
%         % 仅在1个位平面上嵌入
%         name = ['embed_imgs/single/',num2str(f), '_', num2str(size_scale(i)*100),'.bmp'];
%         embed_img = lsb_embed(I, watermark, f, name);
        
        % 在1个位平面上嵌入前，将之前的位平面嵌满
        name = ['embed_imgs/match/',num2str(f), '_', num2str(size_scale(i)*100),'.bmp'];
        embed_img = lsb_full_embed(I, watermark, f, full_watermark, name);
        
        % 经历时间
        elapsed_time=cputime-start_time;
        time_spend(num) = elapsed_time;

        save_figure = figure('Name', '图像 - 直方图 - 卡方分析');
        subplot(2,3,1), imshow(I), title('原始图像');
        subplot(2,3,4), imh=imhist(I); bar(imh); title('原始图像直方图');
        subplot(2,3,2), imshow(embed_img), title(['第', num2str(f), '位平面 ', num2str(uint8(size_scale(i)*100)), '%信息']);
        subplot(2,3,5), imh=imhist(embed_img); bar(imh); title('直方图');

        xtick(num) = (size_scale(i)*100+(f-1)*100)/8;
        my_peaksnr(num) = my_psnr(I, embed_img);            % 8bit灰度图像，像素最大值255
        [peaksnr(num), snr(num)] = psnr(embed_img, I);      % 调用MATLAB自带函数
        ssimval(num) = ssim(embed_img, I);                  % 调用MATLAB自带函数
        
        % CHI-SQUARE 卡方检测
        chi_test(embed_img);
        
        % 保存图像
%         saveas(save_figure, [path, ['第', num2str(f), '位平面嵌入', num2str(uint8(size_scale(i)*100)), '%信息'],'.png'])

	end
end

save_figure = figure('Name', '原始载体图像 - 直方图 - 卡方分析');
subplot(2,3,2), imshow(I), title('原始图像');
subplot(2,3,5), imh=imhist(I); bar(imh); title('原始图像直方图');
chi_test(I);
% saveas(save_figure, [path, '原始载体图像.png']);

% 绘制PSNR图像
save_figure = figure('Name', 'PSNR');
plot(xtick, my_peaksnr, '-s'), title('PSNR ~ Watermark Capacity'), xlabel('Capacity % '), ylabel('PSNR');
ax = gca; ax.YLim = [0 85]; 
for i = 1:record_size
    if mod(i,2)==0
        text(xtick(i)-1,my_peaksnr(i)+3,num2str(my_peaksnr(i)));
    else
        text(xtick(i)-1,my_peaksnr(i)-3,num2str(my_peaksnr(i)));
    end
end
set(save_figure, 'PaperUnits', 'centimeters');
set(save_figure, 'PaperPosition', [0 0 35 20]); %x_width=10cm y_width=15cm
% saveas(save_figure, [path, 'PSNR.png'])

% % 使用MATLAB自带函数psnr得出的结果与my_psnr计算结果相同，可以推断my_psnr没有计算错误
% figure, plot(xtick, peaksnr, '-s'), title('PSNR'), xlabel('Capacity % '), ylabel('PSNR');
% ax = gca; ax.YLim = [0 85]; 
% for i = 1:record_size
%     if mod(i,2)==0
%         text(xtick(i)-1,peaksnr(i)+3,num2str(peaksnr(i)));
%     else
%         text(xtick(i)-1,peaksnr(i)-3,num2str(peaksnr(i)));
%     end
%     
% end

% 绘制SSIM（结构相似性，针对嵌入图像）
save_figure = figure('Name', 'SSIM');
plot(xtick, ssimval, '-s'), title('SSIM ~ Watermark Capacity'), xlabel('Capacity % '), ylabel('SSIM');
ax = gca; ax.YLim = [0 1]; 
for i = 1:record_size
    if mod(i,2)==0
        text(xtick(i)-1,ssimval(i)-0.02,num2str(ssimval(i)));
    else
        text(xtick(i)-1,ssimval(i)+0.02,num2str(ssimval(i)));
    end
end
set(save_figure, 'PaperUnits', 'centimeters');
set(save_figure, 'PaperPosition', [0 0 35 20]); %x_width=10cm y_width=15cm
% saveas(save_figure, [path, 'SSIM.png'])

% 绘制时间图像
save_figure = figure('Name', 'Elapsed Time');
plot(xtick, time_spend, '-s'), title('Elapsed Time ~ Watermark Capacity'), xlabel('Capacity % '), ylabel('Time');
% ax = gca; ax.YLim = [0 85]; 
for i = 1:record_size
    if mod(i,2)==0
        text(xtick(i)-1,time_spend(i)-0.2,num2str(time_spend(i)));
    else
        text(xtick(i)-1,time_spend(i)+0.2,num2str(time_spend(i)));
    end
end
set(save_figure, 'PaperUnits', 'centimeters');
set(save_figure, 'PaperPosition', [0 0 35 20]); %x_width=10cm y_width=15cm
% saveas(save_figure, [path, 'TIME.png'])

% % 提取水印
% path = 'embed_imgs/full/1_100.bmp';
% e = imread(path);
% [origin_res_str, origin_res_vector] = lsb_extract(e, 0, 0, 1);
% compare(e, origin_res_vector, '', e, full_watermark, '', '原始');
% % 图像处理
% [deal_lst, deal_name] = multi_handle(e);
% for i = 1:length(deal_lst)
%     [res_str, res_vector] = lsb_extract(deal_lst{i}, 0, 0, 1);
%     compare(e, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
% end


%% LSB匹配
% [x,y]=size(origin_watermark);
% watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256)));
% [s, res1, res2] = lsb_match_embed(I, watermark, 'embed_imgs/match/test.bmp');
% [r1_str, r1_vector] = lsb_extract(res1, x, y, 1);
% [r2_str, r2_vector] = lsb_random_extract(res2, s, x*y, 1);
% r2_vector = reshape(r2_vector, [x, y]);
% diff_sum1 = compare(I, watermark, '', res1, r1_vector, r1_str, '顺序嵌入');
% diff_sum2 = compare(I, watermark, '', res2, r2_vector, r2_str, '随机嵌入');

%% 随机LSB
% % 伪随机数控制器，嵌入位平面1，MLSB
% % 嵌入字符串
% repeat = 2;       % 重复次数
% % n = length(origin_watermark)*16*repeat;         % 每个字符用16位表示
% % watermark = str2vector(origin_watermark, 1, n);
% 
% % 嵌入图片/随机序列
% x = size(origin_watermark,1)*repeat;
% y = size(origin_watermark,2)*repeat;
% n = x*y;
% % watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256)));
% 
% if n>I_x*I_y    % 载体图像
%     disp('秘密信息数量过大（重复次数过多或原始水印过长）');
%     pause;
% end
% 
% [s, res] = lsb_random_embed(I, watermark, 1, 'embed_imgs/random/1.bmp');
% % figure(),subplot(2,2,1),imshow(I),title('原始图像'),subplot(2,2,2),imshow(res), title('随机嵌入水印后的图像');
% % subplot(2,2,3),imh=imhist(I);bar(imh),title('原始图像灰度直方图');subplot(2,2,4),imh=imhist(res);bar(imh),title('随机嵌入水印后的图像灰度直方图');
% [origin_res_str, origin_res_vector] = lsb_random_extract(res,s,n,1);
% origin_res_vector = reshape(origin_res_vector, [x, y]);
% compare(res, origin_res_vector, origin_res_str, zeros(0,0), watermark, '', '零操作');
% [deal_lst, deal_name] = multi_handle(res);
% for i = 1:length(deal_lst)
%     [res_str, res_vector] = lsb_random_extract(deal_lst{i},s,n,1);
%     res_vector = reshape(res_vector, [x, y]);
%     compare(res, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
% end

%% 奇偶校验LSB，滑动窗口
% % 载体图像，待嵌入的字符，重复次数，窗口大小，位平面，文件名
% window_size = 3;
% % % 字符串水印
% % repeat = 1;
% % n = length(origin_watermark)*16*repeat;         % 每个字符用16位表示
% % x = 1;
% % y = n;
% % % 图片水印
% % x = uint16(size(origin_watermark,1)*0.5);
% % y = uint16(size(origin_watermark,2)*0.5);
% % n = x*y;
% % 随机水印
% x = size(origin_watermark,1)*repeat;
% y = size(origin_watermark,2)*repeat;
% n = x*y;
% 
% if mod(window_size,2) ~= 1
%     disp('窗口大小要为奇数');
%     pause;  % quit, exit(0)
% elseif fix(I_x/window_size) * fix(I_y/window_size) < n      % 载体图像大小
%     disp('无法嵌入全部水印');
%     pause;
% else
% %     字符串水印
% %     watermark = str2vector(origin_watermark, x, y);
% %     图片水印
% %     watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256))); % 将水印图像转换为0/1，恢复时.*256
%     % 随机序列水印
%     watermark = vector_vector(origin_watermark, x, y);
%     
%     [res] = lsb_slide_embed(I, watermark, window_size, 1, 'embed_imgs/slide/1.bmp');
%     [origin_res_str, origin_res_vector] = lsb_slide_extract(res, window_size, n);
%     origin_res_vector = reshape(origin_res_vector, [x, y]);         
%     
%     compare(res, origin_res_vector, origin_res_str, zeros(0,0), watermark, '', '零操作');
%     
%     [deal_lst, deal_name] = multi_handle(res);
%     for i = 1:length(deal_lst)
%         [res_str, res_vector] = lsb_slide_extract(deal_lst{i}, window_size, n);
%         res_vector = reshape(res_vector, [x, y]);
%         compare(res, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
%     end
% end