up = imread('../resources/up.jpg');
down = imread('../resources/down.jpg');
figure(1);
subplot(131); imshow(down); title('down.jpg');
subplot(132); imshow(up); title('up.jpg');
impixelinfo;
% 注意：这里uv， xy对应的是图像矩阵的row和column
% up uv
up_coordinate = [62, 100; 141, 69; 178, 252; 301, 122; 
                331, 326; 399, 382; 93, 510];
% down xy
down_coordinate = [482, 300; 441, 388;286, 293; 288, 498; 
                125, 370; 37, 385; 138, 52];
A  = zeros(7, 6);
b = down_coordinate;
for n = 1:7
    a = [1, up_coordinate(n, 1), up_coordinate(n, 2), ...
        up_coordinate(n, 1)^2, up_coordinate(n, 2)^2, ...
        up_coordinate(n, 1) * up_coordinate(n, 2)];
    A(n,1:6) = a;
end
x_star = inv(A'*A) * A' * b;
% answer(4:6, 1) = 0;
% answer(4:6, 2) = 0;

transform_down = zeros(size(up));
[row, column, ~]=size(transform_down);
[down_row, down_column, ~] = size(down);
for u=1:row
    for v=1:column
        vector = [1, u, v, u*u, v*v, u*v];
        down_x = round(vector * x_star(:, 1)) ;
        down_y = round(vector *  x_star(:, 2));
        if(down_x >= 1 && down_x <= down_row && down_y >= 1 && down_y<= down_column)
            transform_down(u, v, :) = down(down_x, down_y, :);    
        end
    end
end
subplot(133); imshow(uint8(transform_down)); title('transform down.jpg');
