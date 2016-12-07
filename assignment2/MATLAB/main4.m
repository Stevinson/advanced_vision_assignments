%%
% Assignment 2 - Questions 4 and 5
%%

% Clear figures
clf

% Load point cloud 
load('fuse.mat');
point_cloud_noisy = fuse_obj;
% Colour list
colour_list = {'g', 'r', 'b', 'y', 'm', 'w', 'k'};

%% Remove some noise
% Turn point cloud into object
point_cloud_noisy_object = pointCloud(point_cloud_noisy(:,1:3));
% Remove noise from this object
[~, ~, outlier_indices] = pcdenoise(point_cloud_noisy_object, 'Threshold', 1);
% Remove ouliers from point cloud
point_cloud = removerows(point_cloud_noisy,'ind',outlier_indices);
% Get size of point cloud
[number_of_points, ~] = size(point_cloud);
% Plot this object
pcshow(point_cloud(:, 1:3))

%% Extract planes
[planes, points_matrix] = extract_planes(point_cloud, colour_list);

%% Calculate Points
ground_plane = [0, -0.57, 0.82, -749.3];
%all_planes = [planes; ground_plane];
%get_vertices(all_planes)

%% Draw Patches
draw_patches(vertices)





