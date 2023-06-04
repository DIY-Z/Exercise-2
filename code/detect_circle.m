% % clc;
close all;
clear all;

% Read Colour Image and convert it to a grey level Image
% Display the original Image
% Read the image that have circles
i=imread('img.png');
imshow(i)
% 去噪处理
denoisedImage = medfilt2(rgb2gray(i));

% show image
imshow(denoisedImage)

% select max & min threshold of circles we want to detect(define radius
% range)
Rmin = 9;
Rmax = 50;

% Apply Hough circular transform
[centerslight1, radilight1] = imfindcircles(denoisedImage, [Rmin Rmax], Sensitivity=0.89);
[centersdark1, radidark1] = imfindcircles(denoisedImage, [Rmin, Rmax], ObjectPolarity="dark");

% show the detected circles by Red color --
viscircles(centerslight1, radilight1,'LineStyle','--')
viscircles(centersdark1, radidark1, 'LineStyle','--')

% traverse the centerslight1 and centerdark1
% 初始化最小距离和对应的点下标
minDistance = 3;
minPairs = [];
% 遍历所有点对
for i=1:size(centerslight1, 1)
    for j=1:size(centersdark1, 1)
        % 计算点对之间的距离
        distance = norm(centerslight1(i, :) - centersdark1(j, :));
        % 如果距离小于当前最小距离,则把它插入到minPairs中
        if distance < minDistance
            minDistance = distance;
            minPairs = [minPairs; i, j];
        end
    end
end
% 打印结果
fprintf('有孔圆环共有%d个：\n', size(minPairs, 1));
% fprintf('距离最近的点对共有%d对：\n', size(minPairs, 1));
for k = 1:size(minPairs, 1)
    pairIndex = minPairs(k, :);
    % fprintf('第%d对点的下标为：%d, %d\n', k, pairIndex(1), pairIndex(2));
    fprintf('第%d个有孔圆环的坐标为: (%f, %f), 内半径为: %f, 外半径为: %f\n', k,centerslight1(pairIndex(1), 1), centerslight1(pairIndex(1), 2), radidark1(pairIndex(2), 1), radilight1(pairIndex(1), 1));
    % fprintf('它们的坐标分别为：(%f, %f), (%f, %f)\n', centerslight1(pairIndex(1), 1), centerslight1(pairIndex(1), 2), centersdark1(pairIndex(2), 1), centersdark1(pairIndex(2), 2));
end
% 打印不在最小点对中的剩余点
remainingIndices = setdiff(1:size(centerslight1, 1), minPairs(:, 1));
fprintf('无孔圆环共有%d个：\n', length(remainingIndices))
for i = 1:length(remainingIndices)
    index = remainingIndices(i);
    fprintf('第%d个无孔圆环的坐标为：(%f, %f),半径为: %f\n', i, centerslight1(index, 1), centerslight1(index, 2), radilight1(index, 1));
end