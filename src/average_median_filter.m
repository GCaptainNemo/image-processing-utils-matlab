grid = imread('../resources/add_noise.jpg');
grid = rgb2gray(grid);
grid = imnoise(grid,'salt & pepper',0.02);
% grid = imnoise(grid,'gaussian');
I_3 = temp('average',[3, 3]); %3*3均值滤波
I_5 = temp('average',[5, 5]);
I_7 = temp('average',[7, 7]);
% med_3 = medfilt2(grid, [3, 3]);
tic;
med_3 = mymedian(grid, [3, 3]);
med_5 = mymedian(grid, [5, 5]);
med_7 = mymedian(grid, [7, 7]);
toc;disp(['中值滤波运行时间: ',num2str(toc)]);
tic;
average_3 = myfilt(grid, I_3);
average_5 = myfilt(grid, I_5);
average_7 = myfilt(grid, I_7);
toc;disp(['均值滤波运行时间: ',num2str(toc)]);


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


function template = temp(text, size)
if strcmp(text, 'average')
    template = ones(size) / size(1) / size(2);
    return
end
end

function out = myfilt(img, temp)
[temprow, tempcolumn] = size(temp);
[row, column] = size(img);
out = zeros(size(img));
padd_row = floor(temprow/ 2); padd_column = floor(tempcolumn / 2);
img = [zeros(row, padd_column), img, zeros(row, padd_column)];
img = [zeros(padd_row, column + 2*padd_column); img; zeros(padd_row, column + 2*padd_column)];
img = double(img);
for row_ = padd_row+1:padd_row + row 
    for column_ = padd_column+1:padd_column + column
       out(row_ - padd_row, column_ - padd_column) = sum(sum(img(row_-padd_row:row_+padd_row, ...
       column_-padd_column:column_+padd_column) .* temp));
    end
end
out = uint8(out);
end

function out = mymedian(img, temp)
temprow = temp(1); tempcolumn = temp(2);
[row, column] = size(img);
out = zeros(size(img));
padd_row = floor(temprow/ 2); padd_column = floor(tempcolumn / 2);
img = [zeros(row, padd_column), img, zeros(row, padd_column)];
img = [zeros(padd_row, column + 2*padd_column); img; zeros(padd_row, column + 2*padd_column)];
img = double(img);
for row_ = padd_row+1:padd_row + row 
    for column_ = padd_column+1:padd_column + column
       out(row_ - padd_row, column_ - padd_column) = median(reshape(img(row_-padd_row:row_+padd_row, ...
       column_-padd_column:column_+padd_column),temprow * tempcolumn, 1));
    end
end
out = uint8(out);
end



