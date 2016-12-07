%%
% Function to find a candidate planar patch
%%

function [fitlist, plane] = select_starting_patch2(point_cloud)

[num_points] = size(point_cloud,1);
tmpnew = zeros(num_points,6);
tmprest = zeros(num_points,6);

% pick a random point until a successful plane is found
success = 0;
while (~success)
    % Pick a random point out of the point cloud
    idx_point = floor(num_points*rand) + 1;
    % XYZ coordinates of random point
    idx_point_xyz = point_cloud(idx_point, 1:3);
    % RGB values of index point
    idx_point_RGB = point_cloud(idx_point, 4:6);
    % find points in the neighborhood of the given point
    threshold_distance = 6;
    % Initialise counts
    fitcount = 0;
    restcount = 0;
    for i = 1 : num_points
        
        dist = norm(point_cloud(i,1:3) - idx_point_xyz);
        % How many points are within threshold distance of selected point
        % and of roughly the same colour
        if (dist < threshold_distance) && (within_range(50, 50, point_cloud(i, 4:6), idx_point_RGB))
            fitcount = fitcount + 1;
            tmpnew(fitcount,:) = point_cloud(i,:);
        else
            restcount = restcount + 1;
            tmprest(restcount,:) = point_cloud(i,:);
        end
    end

    % If there are a certain amount of points nearby...
    if fitcount > 10
        % Fit a plane to the points near the randomly selected point
        [plane, resid] = fitplane(tmpnew(1:fitcount,1:3));
        % Is the fitting error below a threshold?
        if resid < 5
            fitlist = tmpnew(1:fitcount,:);
            return
        end
    end
end