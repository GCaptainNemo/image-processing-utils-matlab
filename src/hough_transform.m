Img  = imread('../resources/�ۺ���ͼ��.jpg');
origin_Img = Img;
% 1. �õ�ñ�任�����ȼ����
se = strel('rectangle',[3 3]);%ѡȡ�ṹԪ��Ϊ3*3�ľ���
Ibot = imbothat(Img, se); % ��ñ�任
figure(1);
subplot(131); imshow(Ibot); title('��ñ�任���ͼ��');
hist = zeros(1, 256);
totalnum = numel(Ibot);

for i = 1:totalnum 
    hist(Ibot(i) + 1) = hist(Ibot(i) + 1) + 1;
end
num = 0;
for i = 256:-1:1
    num = num + hist(i);
    if num / totalnum > 0.01
        graythresh = i - 1;
        break
    end
end
% 2. ����ͳ�ƻҶȶ�ֵ��
bw = im2bw(Ibot, graythresh / 255);
subplot(132); imshow(bw); title('ȡ�Ҷ�ǰ1%��ĻҶ���Ϊ��ֵ���ж�ֵ��');

% 3. Hough�任��ȡֱ��
[H,T,R] = hough(bw);%�����ֵͼ��ı�׼����任��HΪ����任����I,RΪ�������任�ĽǶȺͰ뾶ֵ
P = houghpeaks(H, 3);%��ȡ3����ֵ��
lines=houghlines(bw,T,R,P);%��ȡ�߶�
subplot(133); imshow(bw); title('�Զ�ֵͼ�����hough�任'); hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');%�����߶�
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');%���
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');%�յ�
end

% 4. Hough�任ֱ�߶˵���Ϊ���ӵ㣬����������
stackx = [lines(1).point2(1), lines(1).point1(1)];
stacky = [lines(1).point2(2), lines(1).point1(2)];
[row, column] = size(bw);
mask = zeros([row, column]);
mask(lines(1).point2(2), lines(1).point1(1)) = 1;
mask(lines(1).point2(2), lines(1).point1(1)) = 1;

% ��hough�任��ȡ��ֱ�߶˵���������������ҵ������ͨ����
mask = region_grow(mask, bw, stackx, stacky);  


B = ones(3, 3);
% after_erode = imerode(mask, B);
after_dilate_mask = imdilate(mask, B);
after_erode_mask = imerode(after_dilate_mask, B);


figure(2);
subplot(121); imshow(mask); title('��hough�任�õ��Ķ˵���Ϊ���ӵ㣬�������������ģ');
subplot(122); imshow(after_dilate_mask); title('���ͺ����ģ');


Img(find(after_dilate_mask, 1)) = 0;
figure(3); 
subplot(121); imshow(Img); title('Image'); 
subplot(122); imshow(after_dilate_mask); title('after dilate');

% 5. ��ȡ��ֱ����ģ�󣬽����޲�
% ���򵥵�priority ��Χ��mask���Ȳ�
while ~isempty(find(after_dilate_mask, 1))
    [row_list, column_list] = find(after_dilate_mask, 1);
    max_num = 0; next_index = 0;
    for i = 1:length(row_list)
        num = 0;
        for window_row = -3: 3
            for window_column = -3: 3
                if row_list(i) + window_row > 0 && column_list(i) + window_column > 0
                    if after_dilate_mask(row_list(i) + window_row, column_list(i) + window_column) == 0
                        num = num + 1;
                    end
                end
            end
        end
        if num > max_num
            max_num = num;
            next_index = i;
        end
    end
    grayscale = 0;
    grayscale_lst = [];
    for window_row = -3: 3
        for window_column = -3: 3
            if row_list(next_index) + window_row > 0 && column_list(next_index) + window_column > 0 
                if after_dilate_mask(row_list(next_index) + window_row, ...
                    column_list(next_index) + window_column) == 0
                    grayscale_lst = [grayscale_lst, Img(row_list(next_index) + window_row, ...
                    column_list(next_index) + window_column)];
                end
            end
        end
    end
    after_dilate_mask(row_list(next_index), column_list(next_index)) = 0;
%     Img(row_list(next_index), column_list(next_index)) = median(grayscale_lst);
    Img(row_list(next_index), column_list(next_index)) = sum(grayscale_lst) / numel(grayscale_lst);
    
end

figure(4); 
subplot(121); imshow(origin_Img); title('ԭʼͼ��');
subplot(122); imshow(Img); title('��������ģ��������ֵ�˲������ͼ��');


% ��������������
function mask = region_grow(mask, bw, stackx, stacky)
[row, column] = size(bw);
while ~isempty(stackx) 
    origin_point = [stackx(end), stacky(end)];
    origin_grayscale = bw(origin_point(2), origin_point(1));
    stackx = stackx(1:end - 1);   % ��ջ
    stacky = stacky(1:end - 1);
    for i = -5:5
        if 1 <= origin_point(1) + i && origin_point(1) + i <=  column
            for j = -5:5
                if 1 <= origin_point(2) + j && origin_point(2) + j <=  row 
                    if abs(bw(origin_point(2) + j, origin_point(1) + i) - ...
                        origin_grayscale) < 1 && ...
                        mask(origin_point(2) + j, origin_point(1) + i) ~= 1 ...
                        stackx = [stackx, origin_point(1) + i];  % ��ջ
                        stacky = [stacky, origin_point(2) + j];
                        mask(origin_point(2) + j, origin_point(1) + i) = 1;
                    end
                end
            end
        end
    end
end
end
