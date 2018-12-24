%% �Ƚ���ȡ��������Ϣ
% ���룺ԭʼͼ�����ԭʼͼ����ȡ��������Ϣ����ԭʼͼ����ȡ���ַ�������������ͼ����󣬾�������ͼ����ȡ��������Ϣ���󣬾�������ͼ����ȡ���ַ���
% ���أ�������
function [diff_sum] = compare(img, origin_vector, origin_str, handled_img, handled_vector, handled_str, name)

% ͳ�Ʋ�ͬ������ֵ
diff_sum =  1-double(length(find((origin_vector-handled_vector)~=0)))/(size(origin_vector, 1)*size(origin_vector, 2));

disp('ԭʼ������Ϣ'), disp(origin_str);
disp([name,'��ȡ��������Ϣ']),disp(handled_str);
disp(['��ȷ�����: ', num2str(diff_sum)]);
fprintf('\n');
% figure,subplot(1,2,1),imshow(img),title('Ƕ��������Ϣ��ԭʼͼ��');subplot(1,2,2),imshow(handled_img),title(name);s

% ���ˮӡ��һά���У��Ƚϳ��ͱ任һ��
if size(origin_vector, 1)==1 && size(origin_vector, 2)>100
    x = round(sqrt(length(origin_vector)));
    for i=x:-1:1
        if rem(length(origin_vector), i)==0
            y = length(origin_vector)/i;
            break
        end
    end
    origin_vector = reshape(origin_vector, [i, y]);
    handled_vector = reshape(handled_vector, [i, y]);
end

% ���ˮӡ��ͼƬ
recover_origin_img = uint8(fix((double(origin_vector).*256)));
recover_handled_img = uint8(fix((double(handled_vector).*256)));
diff_img = imsubtract(recover_origin_img, recover_handled_img);
save_figure = figure();
subplot(1,3,1),imshow(recover_origin_img),title('ԭʼ������Ϣ');
subplot(1,3,2),imshow( recover_handled_img);title([name,'��ȡ��Ϣ']);
subplot(1,3,3),imshow(diff_img);title(['��ȷ�����: ', num2str(diff_sum)]);
saveas(save_figure, 'compare.png');
end