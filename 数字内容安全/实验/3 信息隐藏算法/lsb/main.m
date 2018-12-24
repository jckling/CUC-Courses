clc
% clear all
close all

%% ͼ������
img = '../imgs/peppers.bmp';
path = 'result/peppers/';  % �������·��
I = imread(img);
[I_x,I_y] = size(I);


%% ������Ϣ
% % ͼƬ��Ϣ
% origin_watermark = imread('../watermark/cuc.bmp');
% [J_x, J_y] = size(origin_watermark);
% full_watermark = vector_vector(origin_watermark, I_x, I_y);

% % �ַ�����Ϣ
% watermark_path = 'a.txt';
% fileID = fopen(watermark_path,'r');
% formatSpec = '%s';
% origin_watermark = fscanf(fileID,formatSpec);
% fclose(fileID);
% full_watermark = str2vector(origin_watermark, I_x, I_y);

% �����Ϣ
s = rng; 
origin_watermark = uint8(randi([0 1], [10, 10]));      % ������ɢ�ֲ���α�������������
full_watermark = vector_vector(origin_watermark, I_x, I_y);

%% LSB
% ��Ƕ��Ϣ��С
size_scale = [0.2, 0.5, 0.6, 0.8, 1.0];

% ��¼��Ϣ
record_size = uint8(length(size_scale)*8);
xtick = zeros(1, record_size);                                  % ��¼����
my_peaksnr = zeros(1, record_size);                             % ��¼PSNR������my_psnr��
peaksnr = zeros(1, record_size); snr = zeros(1, record_size);   % ��¼psnr��snr������MATLAB�Դ�������
ssimval = zeros(1, record_size);                                % ��¼SSIM���ṹ�����ԣ�
time_spend = double(zeros(1, record_size));                     % ��¼������ʱ��

for f=1:8
	for i=1:length(size_scale)
        % ����
        num = (f-1)*length(size_scale)+i;
        
        % ͳ��ʱ��
        start_time=cputime;
        
        x = round(size_scale(i)*I_x);
        y = round(size_scale(i)*I_y);
%         watermark = str2vector(origin_watermark, x, y); % �ַ�
        watermark = vector_vector(origin_watermark, x, y);    % ����������ͼ��/������У�
        
%         % ����1��λƽ����Ƕ��
%         name = ['embed_imgs/single/',num2str(f), '_', num2str(size_scale(i)*100),'.bmp'];
%         embed_img = lsb_embed(I, watermark, f, name);
        
        % ��1��λƽ����Ƕ��ǰ����֮ǰ��λƽ��Ƕ��
        name = ['embed_imgs/match/',num2str(f), '_', num2str(size_scale(i)*100),'.bmp'];
        embed_img = lsb_full_embed(I, watermark, f, full_watermark, name);
        
        % ����ʱ��
        elapsed_time=cputime-start_time;
        time_spend(num) = elapsed_time;

        save_figure = figure('Name', 'ͼ�� - ֱ��ͼ - ��������');
        subplot(2,3,1), imshow(I), title('ԭʼͼ��');
        subplot(2,3,4), imh=imhist(I); bar(imh); title('ԭʼͼ��ֱ��ͼ');
        subplot(2,3,2), imshow(embed_img), title(['��', num2str(f), 'λƽ�� ', num2str(uint8(size_scale(i)*100)), '%��Ϣ']);
        subplot(2,3,5), imh=imhist(embed_img); bar(imh); title('ֱ��ͼ');

        xtick(num) = (size_scale(i)*100+(f-1)*100)/8;
        my_peaksnr(num) = my_psnr(I, embed_img);            % 8bit�Ҷ�ͼ���������ֵ255
        [peaksnr(num), snr(num)] = psnr(embed_img, I);      % ����MATLAB�Դ�����
        ssimval(num) = ssim(embed_img, I);                  % ����MATLAB�Դ�����
        
        % CHI-SQUARE �������
        chi_test(embed_img);
        
        % ����ͼ��
%         saveas(save_figure, [path, ['��', num2str(f), 'λƽ��Ƕ��', num2str(uint8(size_scale(i)*100)), '%��Ϣ'],'.png'])

	end
end

save_figure = figure('Name', 'ԭʼ����ͼ�� - ֱ��ͼ - ��������');
subplot(2,3,2), imshow(I), title('ԭʼͼ��');
subplot(2,3,5), imh=imhist(I); bar(imh); title('ԭʼͼ��ֱ��ͼ');
chi_test(I);
% saveas(save_figure, [path, 'ԭʼ����ͼ��.png']);

% ����PSNRͼ��
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

% % ʹ��MATLAB�Դ�����psnr�ó��Ľ����my_psnr��������ͬ�������ƶ�my_psnrû�м������
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

% ����SSIM���ṹ�����ԣ����Ƕ��ͼ��
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

% ����ʱ��ͼ��
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

% % ��ȡˮӡ
% path = 'embed_imgs/full/1_100.bmp';
% e = imread(path);
% [origin_res_str, origin_res_vector] = lsb_extract(e, 0, 0, 1);
% compare(e, origin_res_vector, '', e, full_watermark, '', 'ԭʼ');
% % ͼ����
% [deal_lst, deal_name] = multi_handle(e);
% for i = 1:length(deal_lst)
%     [res_str, res_vector] = lsb_extract(deal_lst{i}, 0, 0, 1);
%     compare(e, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
% end


%% LSBƥ��
% [x,y]=size(origin_watermark);
% watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256)));
% [s, res1, res2] = lsb_match_embed(I, watermark, 'embed_imgs/match/test.bmp');
% [r1_str, r1_vector] = lsb_extract(res1, x, y, 1);
% [r2_str, r2_vector] = lsb_random_extract(res2, s, x*y, 1);
% r2_vector = reshape(r2_vector, [x, y]);
% diff_sum1 = compare(I, watermark, '', res1, r1_vector, r1_str, '˳��Ƕ��');
% diff_sum2 = compare(I, watermark, '', res2, r2_vector, r2_str, '���Ƕ��');

%% ���LSB
% % α�������������Ƕ��λƽ��1��MLSB
% % Ƕ���ַ���
% repeat = 2;       % �ظ�����
% % n = length(origin_watermark)*16*repeat;         % ÿ���ַ���16λ��ʾ
% % watermark = str2vector(origin_watermark, 1, n);
% 
% % Ƕ��ͼƬ/�������
% x = size(origin_watermark,1)*repeat;
% y = size(origin_watermark,2)*repeat;
% n = x*y;
% % watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256)));
% 
% if n>I_x*I_y    % ����ͼ��
%     disp('������Ϣ���������ظ����������ԭʼˮӡ������');
%     pause;
% end
% 
% [s, res] = lsb_random_embed(I, watermark, 1, 'embed_imgs/random/1.bmp');
% % figure(),subplot(2,2,1),imshow(I),title('ԭʼͼ��'),subplot(2,2,2),imshow(res), title('���Ƕ��ˮӡ���ͼ��');
% % subplot(2,2,3),imh=imhist(I);bar(imh),title('ԭʼͼ��Ҷ�ֱ��ͼ');subplot(2,2,4),imh=imhist(res);bar(imh),title('���Ƕ��ˮӡ���ͼ��Ҷ�ֱ��ͼ');
% [origin_res_str, origin_res_vector] = lsb_random_extract(res,s,n,1);
% origin_res_vector = reshape(origin_res_vector, [x, y]);
% compare(res, origin_res_vector, origin_res_str, zeros(0,0), watermark, '', '�����');
% [deal_lst, deal_name] = multi_handle(res);
% for i = 1:length(deal_lst)
%     [res_str, res_vector] = lsb_random_extract(deal_lst{i},s,n,1);
%     res_vector = reshape(res_vector, [x, y]);
%     compare(res, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
% end

%% ��żУ��LSB����������
% % ����ͼ�񣬴�Ƕ����ַ����ظ����������ڴ�С��λƽ�棬�ļ���
% window_size = 3;
% % % �ַ���ˮӡ
% % repeat = 1;
% % n = length(origin_watermark)*16*repeat;         % ÿ���ַ���16λ��ʾ
% % x = 1;
% % y = n;
% % % ͼƬˮӡ
% % x = uint16(size(origin_watermark,1)*0.5);
% % y = uint16(size(origin_watermark,2)*0.5);
% % n = x*y;
% % ���ˮӡ
% x = size(origin_watermark,1)*repeat;
% y = size(origin_watermark,2)*repeat;
% n = x*y;
% 
% if mod(window_size,2) ~= 1
%     disp('���ڴ�СҪΪ����');
%     pause;  % quit, exit(0)
% elseif fix(I_x/window_size) * fix(I_y/window_size) < n      % ����ͼ���С
%     disp('�޷�Ƕ��ȫ��ˮӡ');
%     pause;
% else
% %     �ַ���ˮӡ
% %     watermark = str2vector(origin_watermark, x, y);
% %     ͼƬˮӡ
% %     watermark = uint8(fix(double(vector_vector(origin_watermark, x, y)./256))); % ��ˮӡͼ��ת��Ϊ0/1���ָ�ʱ.*256
%     % �������ˮӡ
%     watermark = vector_vector(origin_watermark, x, y);
%     
%     [res] = lsb_slide_embed(I, watermark, window_size, 1, 'embed_imgs/slide/1.bmp');
%     [origin_res_str, origin_res_vector] = lsb_slide_extract(res, window_size, n);
%     origin_res_vector = reshape(origin_res_vector, [x, y]);         
%     
%     compare(res, origin_res_vector, origin_res_str, zeros(0,0), watermark, '', '�����');
%     
%     [deal_lst, deal_name] = multi_handle(res);
%     for i = 1:length(deal_lst)
%         [res_str, res_vector] = lsb_slide_extract(deal_lst{i}, window_size, n);
%         res_vector = reshape(res_vector, [x, y]);
%         compare(res, origin_res_vector, origin_res_str, deal_lst{i}, res_vector, res_str, deal_name{i});
%     end
% end