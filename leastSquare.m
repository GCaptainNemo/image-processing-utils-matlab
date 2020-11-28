up = imread('up.jpg');
down = imread('down.jpg');
figure(1);
subplot(131); imshow(down); title('down.jpg');
subplot(132); imshow(up); title('up.jpg');
% 
% impixelinfo;


up_coordinate = [[99, 61]; [71, 141]; [252, 174]; [119, 312]; 
                [326, 331]; [382, 399]; [510, 93]];
down_coordinate = [[300, 482]; [388, 443];[294, 285]; [500, 288]; 
                    [370, 125]; [386, 38]; [53, 139]];
A  = zeros(14, 12);
b = reshape(down_coordinate', 1, 14);
for i = 1:14
    n = ceil(i / 2);
    a = [1, up_coordinate(n, 1), up_coordinate(n, 2), ...
        up_coordinate(n, 1)^2, up_coordinate(n, 2)^2, ...
        up_coordinate(n, 1) * up_coordinate(n, 2)];
    if mod(i, 2) == 0
        A(i, 7:12) = a;
    else
        A(i, 1:6) = a;
    end
end
answer = pinv(A) * b';




