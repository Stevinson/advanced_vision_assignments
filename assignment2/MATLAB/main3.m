%%
%Assignment 2 - Question 3: Registration
%%

% Load required data
load balls.mat
load fg.mat
load obj.mat

% Choose 
base = balls{2};

fuse_obj = [];
for f = 1: size(balls,2)
    % Get xyz data of current view
    cloud = fg_clouds{f}(:,4:6);
    [L,~] = size(obj{f});
    % Get the rotation matrix and the translation
    [R, t] = estPose(balls{f}, base);
    % Translate the object
    trans_obj = R * obj{f}(:,4:6)' + repmat(t, 1, L);
    trans_obj = trans_obj';
    % Keep colour info
    trans_obj = [trans_obj, obj{f}(:,1:3)];
    % Add fused data from this view to fused matrix
    fuse_obj = [fuse_obj;trans_obj]; 
end

% remove ouliner
% [Row, ~] = size(fuse_obj);
% centoid = mean(fuse_obj);
% stdv = sum(std(fuse_obj),2);
% filter = sum(abs(fuse_obj - repmat(centoid, Row, 1)),2) ...
%     < (repmat(stdv, Row, 1) * 1.45);
% fuse_obj = fuse_obj(filter',:);

pcshow(fuse_obj(:,1:3))

save fuse.mat fuse_obj