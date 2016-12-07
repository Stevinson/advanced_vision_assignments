%%
% Function that ... 
% Inputs:
% A: point cloud
% B: baseline view
%%

function [ R, t ] = estPose(A, B)

    centroid_A = mean(A);
    centroid_B = mean(B);

    N = size(A,1);

    %% Find the optimal rotation using singular value decomposition
    % Get covariance H
    H = (A - repmat(centroid_A, N, 1))' * (B - repmat(centroid_B, N, 1));
    % Perform svd
    [U,S,V] = svd(H);
    % Get rotation
    R = V*U';
    
    % Check whether it is the reflection case
    if det(R) < 0
        disp('Reflection detected\n');
        V(:,3) = V(:,3) * -1;
        R = V*U';
    end

    t = -R*centroid_A' + centroid_B';

end

