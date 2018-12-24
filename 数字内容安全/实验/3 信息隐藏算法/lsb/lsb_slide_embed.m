%% ��żУ��LSBǶ��
% ���룺����ͼ��������Ϣ�ַ������ظ�������λƽ�棬�����ļ���
% ���أ��������������Ƕ�������
function [res] = slide_lsb_embed(img, watermark2, window_size, f, name)
n = size(watermark2,1)*size(watermark2,2);  % ˮӡ��С
[I_x, I_y] = size(img);
embed_I = img;
num_x = fix(I_x/window_size);
num_y = fix(I_y/window_size);
count = 1;
watermark1 = watermark2(:);             % ��ά �� һά

% ѡ��λƽ��
for x = 1:num_x
    for y = 1:num_y
        % �жϵ�ǰ�����������ܺͣ�mod2���Ƿ��ˮӡ���
        if mod(sum(sum(embed_I((x-1)*window_size+1:(x-1)*window_size+window_size, (y-1)*window_size+1:(y-1)*window_size+window_size))),2) ~= watermark1(count,1)
            for i = (x-1)*window_size+1:(x-1)*window_size+window_size
                for j = (y-1)*window_size+1:(y-1)*window_size+window_size
                    temp = bitget(embed_I(i, j), f);
                    embed_I(i, j) = bitset(embed_I(i, j), f, ~temp);    % ������������ڵ��������ص����λȡ��
                end
            end
        end
        if count == n   % ˮӡǶ�����������ѭ��
            break;
        else
            count = count+1;
        end
    end
    if count == n       % ˮӡǶ�����������ѭ��
        break;
    end
end
    
imwrite(embed_I, name); % д���ļ�
res = embed_I;          % ���ؾ���
end