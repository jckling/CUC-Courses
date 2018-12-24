%% LSBƥ��Ƕ��
% ���룺ԭʼ����ͼ��������Ϣ���󣬱�����ļ���
% ���������������ӣ�����ͼ��1������ͼ��2
function [s, res1, res2] = lsb_match_embed(img, watermark, name)
embed_I1 = img;
embed_I2 = img;
[I_x, I_y] = size(img);
[M_x, M_y] = size(watermark);
n = M_x*M_y;

% ����������н��С�1
select = (-1).^randi([0 1], n, 1);

% ��(1,1)��ʼǶ��
count = 1;
for i=1:M_y
	for j=1:M_x
        if bitget(embed_I1(i,j),1) ~= watermark(i,j)
            if embed_I1(i,j)==0
                embed_I1(i,j) = embed_I1(i,j)+1;
            elseif embed_I1(i,j)==255
                embed_I1(i,j) = embed_I1(i,j)-1;
            else
                embed_I1(i,j) = embed_I1(i,j)+select(count);
            end
            count = count+1;
        end
	end
end

% ���Ƕ��
if n>I_x*I_y    % ����ͼ��
    disp('������Ϣ��������');
    pause;
end
    

% ˮӡһά��
watermark1 = watermark(:);      % ��ά �� һά
% ���λ��
s = rng;
pos = randperm(I_x*I_y, n);
[x, y]=ind2sub([I_x, I_y], pos);    % ��������±�
count = 1;
for i=1:n
	if bitget(embed_I2(x(i),y(i)),1) ~= watermark1(i)
        if embed_I2(x(i),y(i))==0
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))+1;
        elseif embed_I2(x(i),y(i))==255
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))-1;
        else
            embed_I2(x(i),y(i)) = embed_I2(x(i),y(i))+select(count);
        end
	count = count+1;
    end
end


imwrite(embed_I1, name);    % д���ļ�
imwrite(embed_I2, name);    % д���ļ�
res1 = embed_I1;            % ���ؾ���1
res2 = embed_I2;            % ���ؾ���2
end