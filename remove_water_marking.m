grid = imread('grid.bmp');
grid2f = fft2(grid);

grid2f = fftshift(grid2f);

% filter
a = grid2f;
a(129, 138) = 0;
a(129, 120) = 0;
removewater_marking = fftshift(a);
removewater_marking = uint8(ifft2(removewater_marking));

% 
grid2f = abs(grid2f);
grid2f=log(grid2f+1);

figure(1);



% figure(2);
% subplot(131); imshow([grid, grid]);title('ԭͼ��');
subplot(131); imshow(grid);title('ԭͼ��');

impixelinfo;

subplot(132);imshow(grid2f, []);title('Ƶ��ͼ��');
% imshow([grid, grid]);
subplot(133); imshow(removewater_marking);title('ȥ��ˮӡ');






