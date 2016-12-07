% find a candidate planar patch
function [fitlist,plane] = select_patch(points)

[L,~] = size(points);
tmpnew = zeros(L,6);
tmprest = zeros(L,6);

% pick a random point until a successful plane is found
success = 0;
while ~success
    idx = floor(L*rand) + 1;
    pnt = points(idx, 4:6);
    % find points in the neighborhood of the given point
    DISTTOL = 3.0;
    fitcount = 0;
    restcount = 0;
    for i = 1 : L
        
        dist = norm(points(i,4:6) - pnt);
        if dist < DISTTOL
            fitcount = fitcount + 1;
            tmpnew(fitcount,:) = points(i,:);
        else
            restcount = restcount + 1;
            tmprest(restcount,:) = points(i,:);
        end
    end
    oldlist = tmprest(1:restcount,:);
    fitcount;
    if fitcount > 10
        % fit a plane
        [plane,resid] = fitplane(tmpnew(1:fitcount,4:6));
        if resid < 3
            fitlist = tmpnew(1:fitcount,:);
            return
        end
    end
end
