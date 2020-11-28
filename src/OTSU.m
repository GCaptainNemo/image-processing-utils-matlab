grid = imread('grid.bmp');
origingrid = grid;
grayscale = otsu(grid);

for i = 1:numel(grid)
    if grid(i) <= grayscale
        grid(i) = 0;
    else
        grid(i) = 255;
    end
end

% gray = graythresh(grid);
% disp(gray);
% grid = im2bw(grid, gray);
figure(1);
subplot(121); imshow(origingrid); title('ԭͼ');
subplot(122); imshow(grid); title('��ֵ�����ͼ');


function grayscale = otsu(img)
totalNum = numel(img);
g_max = -1;   % ���������䷽��
histogram_ = zeros(1, 256); % ֱ��ͼ
[row, column] = size(img);
for i = 1:row
    for j = 1:column
        histogram_(img(i, j) + 1) = histogram_(img(i, j) + 1) + 1;
    end
end

for cut_ = 1: 255
    w0 = 0;
    w1 = 0;
    u0 = 0;
    u1 = 0;
    for zhifangtuGray = 1:cut_
        w0 = w0 + histogram_(zhifangtuGray);
        u0 = u0 + histogram_(zhifangtuGray) * (zhifangtuGray - 1);
    end
    for zhifangtuGray = cut_ + 1:256
        w1 = w1 + histogram_(zhifangtuGray);
        u1 = u1 + histogram_(zhifangtuGray) * (zhifangtuGray - 1);        
    end
    u0 = u0 / w0; u1 = u1 / w1;
    w0 = w0 / totalNum; w1 = w1 / totalNum;
    g = w0 * w1 * (u1 - u0) ^ 2;
    if g > g_max
        g_max = g;
        grayscale = cut_;
    end
end
end

