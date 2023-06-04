% % clc;
close all;
clear all;

i=imread('img.png');
imshow(i)
% 去噪处理
denoisedImage = medfilt2(rgb2gray(i));

% show image
imshow(denoisedImage)
hold on;

edgeImage = edge(denoisedImage, 'canny');

% imshow(edgeImage)

boundaries = bwboundaries(edgeImage);

rectangles = [];
thresholdArea = 80;
thresholdPerimeter = 20;
thresholdOrientation = 70;


for k = 1:length(boundaries)
    boundary = boundaries{k};
    % 创建一个二值图像，将当前边界点集置为白色，其他部分为黑色
    binaryImage = zeros(size(edgeImage));
    binaryImage(boundary(:,1) + size(edgeImage, 1)*(boundary(:,2)-1)) = 1;
    
    % 计算轮廓的特征
    stats = regionprops(binaryImage, 'Area', 'Perimeter', 'BoundingBox');
    tmp1 = stats.BoundingBox;
    tmp2 = stats.Area;
    tmp3 = stats.Perimeter;
    % 根据特征进行筛选
    if (stats.Area > thresholdArea && stats.Perimeter > thresholdPerimeter && isrectangle(stats.BoundingBox)) 
        % 计算近似的旋转角度
        orientation = abs(atand((stats.BoundingBox(4) - stats.BoundingBox(2)) / (stats.BoundingBox(3) - stats.BoundingBox(1))));
        
        % 判断角度是否接近于90度（可根据需要调整阈值）
        if (orientation > (90 - thresholdOrientation) )
            rectangles = [rectangles; stats.BoundingBox];
        end
        % rectangles = [rectangles; stats.BoundingBox];
    end
end

for k = 1:size(rectangles, 1)
    rectangle('Position', rectangles(k,:), 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;


function result = isrectangle(boundingBox)
    % 提取矩形的位置和尺寸
    x = boundingBox(1);
    y = boundingBox(2);
    width = boundingBox(3);
    height = boundingBox(4);
    
    % 检查是否为矩形
    isRectangle = abs(width - height) > 7 && width > 40 && height > 20;
    
    result = isRectangle;
end

