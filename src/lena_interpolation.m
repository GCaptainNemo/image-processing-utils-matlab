lena = imread('../resources/lena.png');
lena = imresize(lena, 1/ 6);
n = 2; 
zuijinlin_2 = zuijinlin(n, lena);
shuangxianxing_2 = shuangxianxing(n, lena);
sanci_2 = sanci(n, lena);
figure(1);
subplot(131); imshow(zuijinlin_2); title('最近邻');
subplot(132); imshow(shuangxianxing_2); title('双线性');
subplot(133); imshow(sanci_2); title('立方卷积');



function newphoto = zuijinlin(n, lena)
[row, column, ~] = size(lena);
size_ = size(lena);
size_ = size_ .* [n ,n ,1];
newphoto = uint8(zeros(size_));
multiplier = 1 / n;
for i = 1:size_(1)
    oldrow = round(i * multiplier);    
    if oldrow < 1
        oldrow = 1;
    elseif oldrow > row
        oldrow = row;
    end
    for j = 1:size_(2)
        oldcolumn = round(j * multiplier);    
        if oldcolumn< 1
            oldcolumn = 1;
        elseif oldcolumn > column
            oldcolumn = column;
        end
        newphoto(i, j, :) = lena(oldrow, oldcolumn, :);
    end
end

end



function newphoto = shuangxianxing(n, lena)
size_lena = size(lena);
size_ = size_lena .* [n ,n ,1];
newphoto = zeros(size_);
multiplier = 1 / n;
for i = 1:size_(1)
    point_row = i * multiplier;
    oldrow = floor(point_row); 
    proportion_row = point_row - oldrow;        
    if oldrow == 0
            oldrow = 1;
    elseif oldrow == size_lena(1)
        oldrow = size_lena(1) - 1;
    end
    for j = 1:size_(2)
        point_column = j * multiplier;
        oldcolumn = floor(point_column);
        proportion_column = point_column - oldcolumn;
        
        if oldcolumn == 0
            oldcolumn = 1;
        elseif oldcolumn == size_lena(2)
            oldcolumn = size_lena(2) - 1;
        end
       
        newphoto(i, j, :) = ...
        lena(oldrow, oldcolumn, :) * (1 - proportion_row) * (1 - proportion_column) + ...
        lena(oldrow + 1, oldcolumn, :) * (proportion_row) * (1 - proportion_column)+  ...
        lena(oldrow, oldcolumn + 1, :) * (1 - proportion_row) * (proportion_column)+ ...
        lena(oldrow + 1, oldcolumn + 1, :)* (proportion_row) * (proportion_column);
    end
end
newphoto = uint8(newphoto);
end



function newphoto = sanci(n, lena)
size_lena = size(lena);
size_ = size_lena .* [n ,n ,1];
newphoto = zeros(size_);
multiplier = 1 / n;
B = zeros(4, 4, 3);
for i = 1:size_(1)
    pointRow = i * multiplier;
    floorrow = floor(i * multiplier);    
    row_xiaoshu = pointRow - floorrow;
    A = [calculate_cubic(row_xiaoshu - 2) , calculate_cubic(row_xiaoshu - 1), ...
            calculate_cubic(row_xiaoshu),calculate_cubic(row_xiaoshu + 1),];
    if floorrow < 2
        floorrow = 2;
    elseif floorrow > size_lena(1) - 2
        floorrow = size_lena(1) - 2;
    end
    for j = 1:size_(2)
        pointColumn = j * multiplier;
        floorcolumn = floor(j * multiplier);
        column_xiaoshu = pointColumn - floorcolumn;
        C = [calculate_cubic(column_xiaoshu - 2), calculate_cubic(column_xiaoshu - 1), ...
            calculate_cubic(column_xiaoshu),calculate_cubic(column_xiaoshu + 1),];
        if floorcolumn < 2
            floorcolumn = 2;
        elseif floorcolumn > size_lena(2) - 2
            floorcolumn = size_lena(2) - 2;
        end
        for B_row = 1:4
            for B_column = 1:4
                B(B_row, B_column, :) = lena(floorrow + 3 - B_row, floorcolumn + 3 - B_column, :);
            end
        end
        for k = 1:3
            newphoto(i, j, k)  = A * B(:, :, k) * C';
        end
    end
    newphoto = uint8(newphoto);
end

end

function cubic = calculate_cubic(z)
c = abs(z);
if c <= 1
    cubic = 1 - 2 * c^2 + c^3;
elseif c < 2
    cubic = 4 - 8 * c  + 5 * c^2 - c^3;
else
    cubic = 0;
end
end


