% 读取图像
image = imread('img2.png');

% 将图像转换为灰度图像
grayImage = rgb2gray(image);

% figure;
% imshow(grayImage);

% 去噪处理
seD = strel('square',2);
denoisedImage = imerode(grayImage, seD);
% figure;
% imshow(denoisedImage);

se = strel('rectangle', [5,2]);
closeBW = imclose(denoisedImage,se);
% figure, imshow(closeBW);

se = strel('disk',3, 8);
tophatFiltered = imtophat(closeBW,se);
% figure;
% imshow(tophatFiltered);

se = strel('square', 2);
BW2 = imdilate(tophatFiltered,se);
% figure;
% imshow(BW2);

% 使用Canny边缘检测算法来检测边缘
edgeImage = edge(BW2, 'Canny');

% figure;
% imshow(edgeImage);
% hold on;

% 运行Hough变换来检测直线
[H,theta,rho] = hough(edgeImage);

% 设置阈值来选择直线
threshold = 0.5 * max(H(:));
peaks = houghpeaks(H, 3, 'Threshold', threshold);

% 提取直线参数
lines = houghlines(edgeImage, theta, rho, peaks);

% 绘制检测到的直线
figure, imshow(grayImage), hold on
fprintf('共有%d条直线：\n', length(lines));
for k = 1:length(lines)
    fprintf('第%d条直线：\n', k);
    fprintf('端点坐标:(%d, %d), (%d, %d)\n', lines(k).point1(1), lines(k).point1(2), lines(k).point2(1), lines(k).point2(2));
    endpoints = [lines(k).point1; lines(k).point2];
    plot(endpoints(:,1), endpoints(:,2), 'LineWidth', 2, 'Color', 'r');
end
hold off