% Sort regions by size
%%

function  [id, stats] = size_order(image)

    % connected parts in the image
    connected = bwconncomp(image,8);
    % label them
    labeled = bwlabel(image,4);
    % get statistics of the connected regions
    stats = regionprops(connected, 'Area', 'Centroid', 'BoundingBox',...
        'MajorAxisLength','MinorAxisLength', 'Orientation');
    sz = size(stats);
    statsBefore = stats;
    for i = 1:sz
     if stats(i).Area > 1000 && stats(i).MajorAxisLength > 50
        %Get the centroids x
        centx = stats(i).Centroid(1);
        %Get the centroids y
        centy = stats(i).Centroid(2); 
        theta = stats(i).Orientation; 
        majorAxis = (stats(i).MajorAxisLength/4.);
        stats(i).Centroid(1) = centx + (majorAxis*cos(theta));
        stats(i).Centroid(2) = centy + (majorAxis*sin(theta));
        stats(i).Area = pi*(majorAxis^2);
        sEnd = numel(stats)+1;
        stats(sEnd).Centroid(1) = centx - (majorAxis*cos(theta)); 
        stats(sEnd).Centroid(2) = centy - (majorAxis*sin(theta));
        stats(sEnd).Area = pi*(majorAxis^2);
     end
    end
%      siz = size(stats)
    % stats of the connected objects
    [N,W] = size(stats);
%     % bubble sort
    id = zeros(N,1);
    for i = 1 : N
      id(i) = i;
    end
%     for i = 1 : N-1
%         for j = i+1 : N
%             if stats(i).Area < stats(j).Area
%                 tmp = stats(i);
%                 stats(i) = stats(j);
%                 stats(j) = tmp;
%                 tmp = id(i);
%                 id(i) = id(j);
%                 id(j) = tmp;
%             end
%         end
%     end
end