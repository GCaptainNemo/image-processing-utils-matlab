I = imread('../resources/lena.png');
I = rgb2gray(I);
bw_roberts = edge(I,'roberts');
bw_sobel = edge(I,'sobel');
bw_laplace = laplace(I, 0.1);
bw_kirsch = kirsch(I);
figure(1);
subplot(151); imshow(I); title('原图像');
subplot(152); imshow(bw_roberts); title('Roberts算子');
subplot(153); imshow(bw_sobel); title('Sobel算子');
subplot(154); imshow(bw_laplace); title('laplace算子');
subplot(155); imshow(bw_kirsch); title('kirsch算子');

function Img_lap = laplace(Img,threshold)
lenna_3 = mat2gray(Img);   %图像矩阵的归一化
[m,n] = size(lenna_3);
lenna_4 = lenna_3;       %保留图像的边缘一个像素
L = 0;
t = threshold;          %设定阈值
%Laplace算子
for j=2:m-1 
    for k=2:n-1
        L=abs(4*lenna_3(j,k)-lenna_3(j-1,k)-lenna_3(j+1,k)-lenna_3(j,k+1)-lenna_3(j,k-1));
        if(L > t)
            Img_lap(j,k)=255;  %白
        else
            Img_lap(j,k)=0;    %黑
        end
    end
end

end


function Img_kir = kirsch(Img)

%提取图象边缘
t = 250000; %设定阈值
Img5 = double(Img);            
[m,n] = size(Img5);             
g = zeros(m,n); 
d = zeros(1,8);
%利用Kirsch算子进行边缘提取
for i=2:m-1
   for j=2:n-1
       d(1) =(5*Img5(i-1,j-1)+5*Img5(i-1,j)+5*Img5(i-1,j+1)-3*Img5(i,j-1)-3*Img5(i,j+1)-3*Img5(i+1,j-1)-3*Img5(i+1,j)-3*Img5(i+1,j+1))^2; 
       d(2) =((-3)*Img5(i-1,j-1)+5*Img5(i-1,j)+5*Img5(i-1,j+1)-3*Img5(i,j-1)+5*Img5(i,j+1)-3*Img5(i+1,j-1)-3*Img5(i+1,j)-3*Img5(i+1,j+1))^2; 
       d(3) =((-3)*Img5(i-1,j-1)-3*Img5(i-1,j)+5*Img5(i-1,j+1)-3*Img5(i,j-1)+5*Img5(i,j+1)-3*Img5(i+1,j-1)-3*Img5(i+1,j)+5*Img5(i+1,j+1))^2; 
       d(4) =((-3)*Img5(i-1,j-1)-3*Img5(i-1,j)-3*Img5(i-1,j+1)-3*Img5(i,j-1)+5*Img5(i,j+1)-3*Img5(i+1,j-1)+5*Img5(i+1,j)+5*Img5(i+1,j+1))^2; 
       d(5) =((-3)*Img5(i-1,j-1)-3*Img5(i-1,j)-3*Img5(i-1,j+1)-3*Img5(i,j-1)-3*Img5(i,j+1)+5*Img5(i+1,j-1)+5*Img5(i+1,j)+5*Img5(i+1,j+1))^2; 
       d(6) =((-3)*Img5(i-1,j-1)-3*Img5(i-1,j)-3*Img5(i-1,j+1)+5*Img5(i,j-1)-3*Img5(i,j+1)+5*Img5(i+1,j-1)+5*Img5(i+1,j)-3*Img5(i+1,j+1))^2; 
       d(7) =(5*Img5(i-1,j-1)-3*Img5(i-1,j)-3*Img5(i-1,j+1)+5*Img5(i,j-1)-3*Img5(i,j+1)+5*Img5(i+1,j-1)-3*Img5(i+1,j)-3*Img5(i+1,j+1))^2; 
       d(8) =(5*Img5(i-1,j-1)+5*Img5(i-1,j)-3*Img5(i-1,j+1)+5*Img5(i,j-1)-3*Img5(i,j+1)-3*Img5(i+1,j-1)-3*Img5(i+1,j)-3*Img5(i+1,j+1))^2;      
       g(i,j) = max(d);
    end
end

%显示边缘提取后的图象

for i=1:m
    for j=1:n
        if g(i,j)>t
            Img_kir(i,j) = 255;           
        else
            Img_kir(i,j) = 0;
        end
    end
end
end
