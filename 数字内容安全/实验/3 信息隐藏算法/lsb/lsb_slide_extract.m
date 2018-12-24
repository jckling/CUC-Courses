%% ��żУ��LSB��ȡ
% ���룺����ͼ�񣬴��ڴ�С��������λƽ��
% ���أ��ַ�����������Ϣ����
function [res_str, res_vector] = lsb_slide_extract(img, window_size, n)
embed_I = img;
[I_x,I_y] = size(img);
if mod(window_size,2) ~= 1
    disp('���ڴ�СҪΪ����');
    pause;
elseif fix(I_x/window_size) * fix(I_y/window_size) < n
    disp('����̫���޷���ȡȫ��ˮӡ');
    pause;
else
    num_x = fix(I_x/window_size);
    num_y = fix(I_y/window_size);
    extract_watermark = uint8(zeros(n, 1));
    count = 1;
    for x = 1:num_x
        for y = 1:num_y
            extract_watermark(count) =  mod(sum(sum(embed_I((x-1)*window_size+1:(x-1)*window_size+window_size, (y-1)*window_size+1:(y-1)*window_size+window_size))),2);
            if count == n       % ������Ϣ��ȡ���������ѭ��
                break;
            else
                count = count +1;
            end
        end
        if count == n           % ������Ϣ��ȡ���������ѭ��
                break;
        end
    end
    res_str = vector2str(extract_watermark);    % �����ַ�
    res_vector = extract_watermark;             % ���ؾ���
end
end