% 读取图像
image = imread('img2.png');

% 将图像转换为灰度图像
grayImage = rgb2gray(image);

% 去噪处理
denoisedImage = medfilt2(grayImage);

figure;
imshow(denoisedImage);
hold on;

% 使用腐蚀操作来消除分散的点
seD = strel('diamond',1);
BWfinal = imerode(denoisedImage,seD);
% figure;
% imshow(BWfinal);
% hold on;

% 先检测矩形的角点
corners = detectMinEigenFeatures(BWfinal);
rectangle_corners = corners.selectStrongest(8);
locations = rectangle_corners.Location;
plot(rectangle_corners);
hold on;


% 设置要聚类的簇的数量
k = 2;
% 使用 k-means 进行聚类
[idx, centroids] = kmeans(locations, k, "Distance","cosine");

% 将角点分为两类
cluster1 = locations(idx == 1, :);
cluster2 = locations(idx == 2, :);

% 绘制结果
% figure;
% scatter(cluster1(:, 1), cluster1(:, 2), 'r');
% hold on;
% scatter(cluster2(:, 1), cluster2(:, 2), 'b');
% scatter(centroids(:, 1), centroids(:, 2), 'k', 'filled');
% legend('Cluster 1', 'Cluster 2', 'Centroids');
% xlabel('X');
% ylabel('Y');
% title('Clustering Result');

k1 = convhull(double(cluster1));
plot(cluster1(k1,1),cluster1(k1,2), 'LineWidth', 3, 'LineStyle','-');

k2 = convhull(double(cluster2));
plot(cluster2(k2,1),cluster2(k2,2), 'LineWidth', 3, 'LineStyle','-');


%% 对第一个矩形进行计算
% 去掉列表k的最后一个元素
k1 = k1(1:end-1);
% 根据索引提取凸包的顶点坐标
convhull_vertices1 = cluster1(k1, :);
% 计算凸包的边长信息
edge_lengths = zeros(size(convhull_vertices1, 1), 1);
for i = 1:size(convhull_vertices1, 1)
    x1 = convhull_vertices1(i, 1);
    y1 = convhull_vertices1(i, 2);
    x2 = convhull_vertices1(mod(i, size(convhull_vertices1, 1)) + 1, 1);
    y2 = convhull_vertices1(mod(i, size(convhull_vertices1, 1)) + 1, 2);
    distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    edge_lengths(i) = distance;
end

% 计算矩形的边长信息
min_edge_length = min(edge_lengths);
max_edge_length = max(edge_lengths);

% 计算矩形的质心坐标
centroid = mean(convhull_vertices1);

% 打印结果
disp('第一个矩形:');
disp(['最小边长: ', num2str(min_edge_length)]);
disp(['最大边长: ', num2str(max_edge_length)]);
fprintf('质心坐标: (%f,%f)\n', centroid(1), centroid(2))

%% 对第二个矩形进行计算
% 去掉列表k的最后一个元素
k2 = k2(1:end-1);
% 根据索引提取凸包的顶点坐标
convhull_vertices2 = cluster2(k2, :);
% 计算凸包的边长信息
edge_lengths = zeros(size(convhull_vertices2, 1), 1);
for i = 1:size(convhull_vertices2, 1)
    x1 = convhull_vertices2(i, 1);
    y1 = convhull_vertices2(i, 2);
    x2 = convhull_vertices2(mod(i, size(convhull_vertices2, 1)) + 1, 1);
    y2 = convhull_vertices2(mod(i, size(convhull_vertices2, 1)) + 1, 2);
    distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    edge_lengths(i) = distance;
end

% 计算矩形的边长信息
min_edge_length = min(edge_lengths);
max_edge_length = max(edge_lengths);

% 计算矩形的质心坐标
centroid = mean(convhull_vertices2);

% 打印结果
disp('第二个矩形:');
disp(['最小边长: ', num2str(min_edge_length)]);
disp(['最大边长: ', num2str(max_edge_length)]);
% disp(['质心坐标: ', num2str(centroid)]);
fprintf('质心坐标: (%f,%f)\n', centroid(1), centroid(2))