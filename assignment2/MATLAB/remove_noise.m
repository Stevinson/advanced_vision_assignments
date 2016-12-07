%%
% Function to remove noise from point cloud
%%

function point_cloud = remove_noise(noisy_cloud)

%% Remove some noise
% Turn point cloud into object
point_cloud_noisy_object = pointCloud(noisy_cloud(:,1:3));
% Remove noise from this object
[~, ~, outlier_indices] = pcdenoise(point_cloud_noisy_object, 'Threshold', 1);
% Remove ouliers from point cloud
point_cloud = removerows(noisy_cloud,'ind',outlier_indices);
% Get size of point cloud
% [number_of_points, ~] = size(point_cloud);
% Plot this object
pcshow(point_cloud(:, 1:3))


end