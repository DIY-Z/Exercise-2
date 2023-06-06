% 读取图像
image = imread('img2.png');

% 将图像转换为灰度图像
grayImage = rgb2gray(image);

figure;
imshow(grayImage);


% 去噪处理
denoisedImage = medfilt2(grayImage);

figure;
imshow(denoisedImage);

fig2 = SideWindowBoxFilter(denoisedImage, 1, 54);

figure;
imshow(fig2);

% 使用Canny边缘检测算法来检测边缘
edgeImage = edge(fig2, 'Canny');
% figure;
% imshow(edgeImage);

se = strel('disk', 3);
edgeImage = imclose(edgeImage,se);
figure, imshow(edgeImage)

% 运行Hough变换来检测直线
[H,theta,rho] = hough(edgeImage);

% 设置阈值来选择直线
threshold = 0.5 * max(H(:));
peaks = houghpeaks(H, 3, 'Threshold', threshold);

% 提取直线参数
lines = houghlines(edgeImage, theta, rho, peaks);

% 绘制检测到的直线
figure, imshow(denoisedImage), hold on
for k = 1:length(lines)
    endpoints = [lines(k).point1; lines(k).point2];
    plot(endpoints(:,1), endpoints(:,2), 'LineWidth', 2, 'Color', 'r');
end
hold off

