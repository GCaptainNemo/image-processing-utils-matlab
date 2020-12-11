grid = imread('../resources/lena.png');
grid = rgb2gray(grid);
origin_grid = grid;
min_val = min(min(grid));
max_val = min(max(grid));
k = 200 / (155 - 25);
b = 0;
for i = 1:numel(grid)
    grid(i) = grid(i) * k + b;
    if grid(i) < 0
        grid(i) = 0;
    end
    if grid(i) > 255
        grid(i) = 255;
    end
end
figure(1);
subplot(121); imshow(grid); title('原图');
subplot(122); imshow(origin_grid); title('灰度线性拉伸后');
figure(2);
subplot(121);imhist(grid); title('原图');
subplot(122); imhist(origin_grid); title('灰度线性拉伸后');
