I  = imread('综合题图像.jpg');
% 用低帽变换做波谷检测器
se = strel('rectangle',[3 3]);%选取结构元素为3*3的矩形
Ibot = imbothat(I, se); % 低帽变换
subplot(131); imshow(Ibot); 
hist = zeros(1, 256);
totalnum = numel(Ibot);

for i = 1:totalnum 
    hist(Ibot(i) + 1) = hist(Ibot(i) + 1) + 1;
end
num = 0;
for i = 256:-1:1
    num = num + hist(i);
    if num / totalnum > 0.01
        graythresh = i - 1;
        break
    end
end
bw = im2bw(Ibot, graythresh / 255);
subplot(132); imshow(bw);
[H,T,R] = hough(bw);%计算二值图像的标准霍夫变换，H为霍夫变换矩阵，I,R为计算霍夫变换的角度和半径值
P = houghpeaks(H, 3);%提取3个极值点
% x = T(P(:,2)); 
% y = R(P(:,1));
% plot(x, y, 's', 'color', 'white');%标出极值点
lines=houghlines(bw,T,R,P);%提取线段
subplot(133); imshow(bw); hold on;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');%画出线段
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');%起点
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');%终点
end

stackx = [lines(1).point2(1), lines(1).point1(1)];
stacky = [lines(1).point2(2), lines(1).point1(2)];
[row, column] = size(bw);
mask = zeros([row, column]);
mask(growpoint) = 1;
% 对hough变换提取的直线端点进行区域生长，找到最大连通区域
mask = region_grow(mask, bw, stackx, stacky);  


B = ones(3, 3);
% after_erode = imerode(mask, B);
after_dilate = imdilate(mask, B);
after_erode = imerode(after_dilate, B);


figure(2);
subplot(131); imshow(mask); title('mask');
subplot(132); imshow(after_dilate); title('after dilate');
subplot(133); imshow(after_erode); title('after erode');

% [row, column] = find(after_dilate);
I(find(after_dilate)) = 0;
% figure(3); imshow(I);


% while ~isempty(find(mask))
%     edge_mask = edge(mask, 'canny');
%     [row_list, column_list] = find(edge_mask);
%     num = 0;
%     grayscale = 0;
%     for row_index = 1:length(row_list)
%         row = row_list(row_index); column = column_list(row_index);
%         for i = -3:3
%             for j = -3:3
%                 if row + i > 0 && column + j > 0 && mask(row+i, column + j) == 0 
%                     num = num + 1;
%                     grayscale = grayscale + mask(row + i, column + j);
%                 end
%             end
%         end
%         I(row, column) = grayscale / num;
%         mask(row, column) = 0;
%     end
%     
%     
% end
% 
% figure(3); imshow(I);


function mask = region_grow(mask, bw, stackx, stacky)
[row, column] = size(bw);
while ~isempty(stackx) 
    origin_point = [stackx(end), stacky(end)];
    origin_grayscale = bw(origin_point(2), origin_point(1));
    stackx = stackx(1:end - 1);   % 出栈
    stacky = stacky(1:end - 1);
    for i = -5:5
        if 1 <= origin_point(1) + i && origin_point(1) + i <=  column
            for j = -5:5
                if 1 <= origin_point(2) + j && origin_point(2) + j <=  row 
                    if abs(bw(origin_point(2) + j, origin_point(1) + i) - ...
                        origin_grayscale) < 1 && ...
                        mask(origin_point(2) + j, origin_point(1) + i) ~= 1 ...
                        stackx = [stackx, origin_point(1) + i];  % 入栈
                        stacky = [stacky, origin_point(2) + j];
                        mask(origin_point(2) + j, origin_point(1) + i) = 1;
                    end
                end
            end
        end
    end
end
end

function res_img = inpaintingOnMask(mask, I)
window_size = 10; inpainting_size = 3; SE = ones(3, 3);
while ~isempty(find(mask))
    dilate_mask = imdilate(mask, B);
    mask_edge = dilate_mask(mask, 'canny');
    [row_list, column_list] = find(mask_edge);
    priority = 0;
    for i = 1:length(row_list)
        % 5 x 5的修补patch
        inpainting_patch = I(row_list(i) - 2:row_list(i) + 2, ...
                            column_list(i) - 2:column_list(i) + 2);
        patch_mask = mask(row_list(i) - 2:row_list(i) + 2, ...
                            column_list(i) - 2:column_list(i) + 2);
        if ~isempty(find(patch_mask))   % patch_mask需要有部分待修补元素
            % 用待修补的元素算proportion priority
            proportion = 1 - length(find(patch_mask)) / length(patch_mask)  
        end
%         max_similarity = 0;
%         max_similarity_patch = [];
        for slide_row = -10: 10  % 开一个10x10的窗口，算structure priority
            for slide_column = -10: 10
                slide_patch = I(row_list(i)  + slide_row - 2:row_list(i) + slide_row  + 2, ...
                            column_list(i ) + slide_column - 2:column_list(i) + 2 + slide_column);
                slide_mask = mask(row_list(i)  + slide_row - 2:row_list(i) + slide_row  + 2, ...
                            column_list(i ) + slide_column - 2:column_list(i) + 2 + slide_column);
                if isempty(find(slide_mask))  % 空才能作为参考
                    slide_patch(find(patch_mask)) = 0;
                    mse = sum(sum((slide_patch - inpaint_patch) .^2)) / ...
                            (length(slide_mask) - length(find(slid_mask)));
                    similarity = exp(- mse / 25);
                    
%                     if similarity > max_similarity
%                         max_similary = similarity;
%                         max_similarity_patch = 
%                     end
                end
            end
        end
        
        
    end
        
    
end
    
end



end


