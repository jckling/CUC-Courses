%% 随机LSB嵌入
% 输入：原始载体图像，秘密信息字符串，重复次数，位平面，保存文件名
% 返回：随机数控制器，嵌入的总数
function [s, res] = lsb_random_embed(img, watermark2, f, name)
embed_I = img;
[I_x, I_y] = size(img);

% 水印大小
x = size(watermark2, 1);
y = size(watermark2, 2);
n = x*y;

% 秘密信息一维化
watermark1 = watermark2(:);      % 二维 → 一维

% 随机选取n个点
s = rng;
select = randperm(I_x*I_y, n);
[position_x, position_y]=ind2sub([I_x, I_y],select);    % 获得索引下标

% 选择位平面进行嵌入
for k=1:n
%         disp([position_x(k), position_y(k),watermark(i, j)]);
	embed_I(position_x(k), position_y(k)) = bitset(embed_I(position_x(k), position_y(k)), f, watermark1(k));
end

imwrite(embed_I, name);     % 写入文件
res = embed_I;              % 返回矩阵
end

%% 随机数
% % 正态分布随机数
% pd = makedist('Normal');
% rng default;  % for reproducibility
% x = random(pd,100,1);
% 
% sx = rng; 
% position_x = uint16(randi(I_x, [1, n]));      % 均匀离散分布的伪随机数（整数）
% % 仅适用与正方形的图像
% m = I_x;
% s = rng;
% k = randperm(m/2*(m-1),n);
% position_x = floor(sqrt(8*(k-1) + 1)/2 + 3/2);
% position_y = k - (position_x-1).*(position_x-2)/2;
% 
% % 方法2
% num_pairs = n;
% max_val = I_x;
% s1 = rng;
% tot_sum = randi(max_val + 1,[num_pairs,1]) - 1; %Need to include 0
% s2 = rng;
% result = rand(num_pairs,2);
% result = bsxfun(@rdivide,result, sum(result,2));
% result = round(bsxfun(@times,result,tot_sum));
% plot(result)
% 
% theNumbers = randperm(50) % Whatever number you want.
% for k = 1 : 2 : length(theNumbers)/2
% 	selection = theNumbers(k:k+1) % Report this selection to command window.
% end
% 
% 其他测试
% n = 15;
% m = 8;
% [x y]=ind2sub([n n],randperm(n*n,m));
% 
% M = nchoosek(1:15, 2);
% T = datasample(M, 8, 'replace', false);
% 
% T = zeros(8,2);
% k = 1;
% while (k <= 8)
%   t = randi(15, [1,2]);
%   b1 = (T(:,1) == t(1));
%   b2 = (T(:,2) == t(2));
%   if ~any(b1 & b2)
%     T(k,:) = t;
%     k = k + 1;
%   end
% end
% 
% x = rand(1, 10000);
% y = rand(1, 10000);
% minAllowableDistance = 0.05;
% numberOfPoints = 300;
% % Initialize first point.
% keeperX = x(1);
% keeperY = y(1);
% % Try dropping down more points.
% counter = 2;
% for k = 2 : numberOfPoints
% 	% Get a trial point.
% 	thisX = x(k);
% 	thisY = y(k);
% 	% See how far is is away from existing keeper points.
% 	distances = sqrt((thisX-keeperX).^2 + (thisY - keeperY).^2);
% 	minDistance = min(distances);
% 	if minDistance >= minAllowableDistance
% 		keeperX(counter) = thisX;
% 		keeperY(counter) = thisY;
% 		counter = counter + 1;
% 	end
% end
% plot(keeperX, keeperY, 'b*');
% grid on;
% 
% N = 10;
% rng;
% X=rand(2,N);
% x=X(1,:);
% y=X(2,:);
% plot(x,y,'.');  
% 
% rng;
% X2 = unifrnd(0,1,2,N);
% x=X(1,:);
% y=X(2,:);
% figure()
% plot(x,y,'.');  
% 
% tiles = [1:8, 1:8];
% tiles = reshape( tiles(randperm(length(tiles))), 4, 4);
