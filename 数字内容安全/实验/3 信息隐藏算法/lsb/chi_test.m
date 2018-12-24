%% 卡方分析
% 输入：待检图像
function chi_test(img)
N=8;    % 分块数量N*N
K=64;   % 分块大小
block = zeros(K,K);
r=0;    % 暂存r值
a=1;    % 计数
hx=zeros(1,K);
pr=zeros(1,N*N);    % r值，越小含密的可能性越大
pc=zeros(1,N*N);    % p值，越接近于1含密的可能性越大
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        block = img(x:x+K-1, y:y+K-1);  % 分块
        [h,bin]=imhist(block);          % 当前分块的灰度直方图
        for i=1:K
            hx(i)=(h(2*i-1)+h(2*i))/2;
            if hx(i)~=0
                r=r+(h(2*i-1)-hx(i))^2/hx(i);
            end
        end
        pr(a)=r;
        pc(a)=1-chi2pdf(r, K-1);
        a=a+1;
        r=0;
    end
end

% 绘图
subplot(2,3,3),plot(pr),title('r=sum(h2i-h2i*)^2/h2i*');
subplot(2,3,6),plot(pc),title(['p=1-chi2pdf(r,',num2str(K-1),')']);

end