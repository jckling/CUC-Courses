%% ��������
% ���룺����ͼ��
function chi_test(img)
N=8;    % �ֿ�����N*N
K=64;   % �ֿ��С
block = zeros(K,K);
r=0;    % �ݴ�rֵ
a=1;    % ����
hx=zeros(1,K);
pr=zeros(1,N*N);    % rֵ��ԽС���ܵĿ�����Խ��
pc=zeros(1,N*N);    % pֵ��Խ�ӽ���1���ܵĿ�����Խ��
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        block = img(x:x+K-1, y:y+K-1);  % �ֿ�
        [h,bin]=imhist(block);          % ��ǰ�ֿ�ĻҶ�ֱ��ͼ
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

% ��ͼ
subplot(2,3,3),plot(pr),title('r=sum(h2i-h2i*)^2/h2i*');
subplot(2,3,6),plot(pc),title(['p=1-chi2pdf(r,',num2str(K-1),')']);

end