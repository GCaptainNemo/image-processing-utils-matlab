grid = imread('add_noise.jpg');
grid = rgb2gray(grid);
% grid = imnoise(grid,'salt & pepper',0.02);
grid = imnoise(grid,'gaussian');
I_3 = temp('average',[3, 3]);%3*3均值滤波
I_5 = temp('average',[5, 5]);%3*3均值滤波
I_7 = temp('average',[7, 7]);%3*3均值滤波


med_3 = medfilt2(grid, [3, 3]);
med_5 = medfilt2(grid, [5, 5]);
med_7 = medfilt2(grid, [7, 7]);
average_3 = imfilter(grid, I_3);
average_5 = imfilter(grid, I_5);
average_7 = imfilter(grid, I_7);

figure(1);
subplot(141);  imshow(grid); title('原图像');

subplot(142);  imshow(average_3); title('3x3均值滤波');
subplot(143);  imshow(average_5); title('5x5均值滤波');
subplot(144);  imshow(average_7); title('7x7均值滤波');

figure(2);
subplot(141);  imshow(grid); title('原图像');

subplot(142);  imshow(med_3); title('3x3中值滤波');
subplot(143);  imshow(med_5); title('5x5中值滤波');
subplot(144);  imshow(med_7); title('7x7中值滤波');
% average_5 = imfilter(grid, I_5);
% average_7 = imfilter(grid, I_7);

function template = temp(text, size)
if strcmp(text, 'average')
    template = ones(size) / size(1) / size(2);
    return
end
end







