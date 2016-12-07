%%
% Assignment 2 - Question 1 
% Extract and remove the ground plane from the image data
%%

% Set output format
format bank
% Colour array
mcolor = {'g', 'r', 'b', 'y', 'm', 'w', 'k'};
% Load data
load('av_pcl.mat');
% Clear current figure
clf
fg_clouds = {};

% Iterate over each view
for f = 1 : 16
    f
    R = pcl_cell{f};
    % Multiply XYZ points?
    R(:,:,4:6) = R(:,:,4:6) * 1000;
    [L,W,~] = size(R);
    % Create depth cloud (307200-by-6) i.e. each point and its RGB & XYZ values
    depth_cloud = reshape(R, L*W, 6);
    
    % remove 0 row
    depth_cloud = depth_cloud(logical(depth_cloud(:,4))  ...
        & logical(depth_cloud(:,5)) & logical(depth_cloud(:,6)),:);
    
    accepted = false;
    while ~accepted
        % Get point cloud without background
        fg_cloud = backgroundsub(depth_cloud);
        
        % Remove ouliners
        [Row, ~] = size(fg_cloud);
        % Mean of X,Y and Z
        centroid = mean(fg_cloud(:,4:6));
        stdv = sum(std(fg_cloud(:,4:6)),2);
        filter = sum(abs(fg_cloud(:,4:6) - repmat(centroid, Row, 1)),2) ...
            < (repmat(stdv, Row, 1) * 3.0);
        fg_cloud = fg_cloud(filter',:);
        
        % k-means 
        [idx, C, sumd, D] = kmeans(fg_cloud(:,4:6), 4, 'Replicates', 3);
        distanceMatrix = squareform(pdist(C));
        stdvDist = std(mean(distanceMatrix))
        if stdvDist >= 41 && stdvDist <= 45
            accepted = true;
        end 
        
        clf
        hold on
        pcshow(fg_cloud(:,4:6))
        hold on
        plot3(C(:,1), C(:,2), C(:,3), 'gh')
    end

    
    fg_clouds{f} = fg_cloud;
    
    
end
