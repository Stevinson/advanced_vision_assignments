%%
% Function which returns the points not on background plane
%%
function [remaining] = backgroundsub(depth_cloud)

    [L,~] = size(depth_cloud);
    while (L > 100000)
        
        [L,~] = size(depth_cloud);
        % 
        [oldlist, plane] = select_patch(depth_cloud);
      
        % Grow plane until break clause reached
        while (true)
            
            % Get points in cloud that are on plane with oldlist
            [newlist, depth_cloud] = getallpoints(plane, oldlist, depth_cloud, L);
        
            [Nold, ~] = size(oldlist);
            [Nnew, ~] = size(newlist);
        
            % If plane growing, continue growing
            if Nnew > Nold + 50
                [plane, ~] = fitplane(newlist(:,4:6));
                oldlist = newlist;
            else 
               [plane, fit] = fitplane(newlist(:,4:6))
               remaining = depth_cloud;
               size(remaining);
              break;
            end
        end
    [L,~] = size(depth_cloud);
end
end

