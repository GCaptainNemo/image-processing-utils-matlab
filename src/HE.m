grid = imread('lena.png');
% imshow(grid);
grid = rgb2gray(grid);
gridHE = Histogram_eq(grid);
% gridHE2 = histeq(grid);
figure(1)
subplot(121); imshow(grid); title('原图');
subplot(122); imshow(gridHE); title('均衡后');
figure(2);
subplot(121);imhist(grid); title('原图');
subplot(122); imhist(gridHE); title('均衡后');

function img = Histogram_eq(img)

histogram = zeros(1, 256);
size_ = size(img);
num = size_(1) * size_(2);
for i = 1:size_(1)
    for j = 1:size_(2)
        grayscale = img(i, j);
        histogram(grayscale + 1) = histogram(grayscale + 1) + 1;
    end
end
sum = 0;
for i = 1:256
    sum = sum + histogram(i);
    histogram(i) = 255 * (sum / num);
end



for i = 1:size_(1)
    for j = 1:size_(2)
        grayscale = img(i, j);
        img(i, j) = histogram(grayscale);
    end
end

end