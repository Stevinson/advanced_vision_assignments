%%
% Assignment 2 - Question 2
% Extract and describe the 3 spheres
%%

% Load foreground point clouds
load fg.mat;

% Array of empty matrices for each ball and object
balls = cell(1,16);
obj = cell(1,16);

% Iterate over each view
for f = 1 :16
    
    % Current cloud
    cloud = fg_clouds{f};
    
    good_cluster = false;
    while (~good_cluster)
        
        % K-means clustering to separate objects
        % C are centroid locations
        [idx, C, sumd, D] = kmeans(cloud(:,4:6), 4, 'Replicates', 3); 
        distanceMatrix = squareform(pdist(C));
        stdvDist = std(mean(distanceMatrix));
        if stdvDist >= 41 && stdvDist <= 45
            good_cluster = true;
        end
    end
    
    figure(f)
    clf
    hold on
    %     pcshow(cloud(:,4:6))
    %     plot3(C(:,1),C(:,2),C(:,3),'k+')
    
    disp(f)
    %% For each cluster change the HSV values to RGB values
    hsvOfClust = zeros(numel(unique(idx)), 1);
    for i = 1 : numel(unique(idx))
        clust = cloud(idx == i,:);
        color = mean(clust(:,1:3));
        color = color / 255;
        hsvcolor = hsv2rgb(color);
        hsvOfClust(i) = hsvcolor(2);
    end
    
    [B,I] = sort(hsvOfClust);
    
    object_cloud = cloud(idx == mode(idx),:);
    obj{f} = object_cloud;
    
    % Create cell for each ball
    ball_clouds = cell(1,3);
    j = 0;
    for i = 1 : size(I,1)
        if I(i) == mode(idx)
            continue;
        end
        j = j + 1;
        ball_cloud = cloud(idx == I(i),:);
        ball_clouds{j} = ball_cloud;
    end
    
    % remove ouliner
    for i = 1 : size(ball_clouds,2)
        cloud = ball_clouds{i};
        distanceMatrix = squareform(pdist(cloud(:,4:6)));
        filter = mean(distanceMatrix) < mean(mean(distanceMatrix)) * 1.5;
        cloud = cloud(filter',:);
        ball_clouds{i} = cloud;
    end
    
    %% Fit a sphere to the 3D data
    center = zeros(3,3);
    [center(1,:),~] = sphereFit(ball_clouds{1}(:,4:6));
    [center(2,:),~] = sphereFit(ball_clouds{2}(:,4:6));
    [center(3,:),~] = sphereFit(ball_clouds{3}(:,4:6));
    balls{f} = center;
    
    plot3(center(:,1), center(:,2), center(:,3), 'k+')
    plot3(ball_clouds{1}(:,4), ball_clouds{1}(:,5), ball_clouds{1}(:,6),'r.')
    plot3(ball_clouds{2}(:,4), ball_clouds{2}(:,5), ball_clouds{2}(:,6),'g.')
    plot3(ball_clouds{3}(:,4), ball_clouds{3}(:,5), ball_clouds{3}(:,6),'b.')
end
save balls.mat balls
save obj.mat obj