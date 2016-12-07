%%
% Function which extracts planes
% Author: Edward Stevinson
%%

function [plane_list, points_matrix] = extract_planes(point_cloud, colours)

    [num_points_in_cloud, ~] = size(point_cloud);
    % patch_id?
    %patch_id = zeros(num_points_in_cloud,1);
    % Store plane parameters
    plane_list = zeros(20,4); 
    %points_matrix = cell(1,9); %...?
    
    % Note - more intelliigent method recommended
    remaining_point_cloud = point_cloud;
    
    % Iterate over ... ?
    for plane_no = 1:20 
        
%         % Remove noise
%         x = remove_noise(remaining_point_cloud);
%         remaining_point_cloud = x;
        
        % Select a random small surface patch (thereby hoping to get the
        % biggest - but this is not the case)
        % Look at this funtion - change it!
        [old_list, plane] = select_starting_patch2(remaining_point_cloud);
        
        
        %% Grow patch
        while (true)
            
            % Find neighbouring points in plane
            still_growing = false;
            [list_of_points_on_plane, remaining] = getallpoints(plane, old_list, remaining_point_cloud, num_points_in_cloud);
            % Because MATLAB is funny...
            remaining_point_cloud = remaining;
            % Store ...
            [number_points_plane, ~] = size(list_of_points_on_plane);
            [length_oldlist, ~] = size(old_list);
            
            if (number_points_plane > length_oldlist + 40)
                [plane, ~] = fitplane(list_of_points_on_plane(:, 1:3));
                old_list = list_of_points_on_plane;
            else
                [plane, ~] = fitplane(list_of_points_on_plane(:, 1:3));
                plane_list(plane_no,:) = plane';
                points_matrix{plane_no} = list_of_points_on_plane; 
                break
            end
        end
        [num_points_in_cloud,~] = size(remaining_point_cloud);
        pcshow(remaining_point_cloud(:,1:3))
    end    
end