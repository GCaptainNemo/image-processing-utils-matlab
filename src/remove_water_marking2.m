grid = imread('grid.bmp');
grid = grid(:, 6:255);

grid2f = fft2(grid);
grid2f = fftshift(grid2f);
% filter
a = grid2f;
a(129, 117) = 0;   %117, 135ʱû������
a(129, 135) = 0;
a = fftshift(a);
removewater_marking = uint8(ifft2(a));

grid2f = abs(grid2f);
grid2f=log(grid2f+1);

subplot(131); imshow(grid);title('ԭͼ��');
impixelinfo;

subplot(132);imshow(grid2f, []);title('Ƶ��ͼ��');
% imshow([grid, grid]);
subplot(133); imshow(removewater_marking);title('ȥ��ˮӡ');

