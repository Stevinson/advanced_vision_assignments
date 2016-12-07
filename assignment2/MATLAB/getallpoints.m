% selects all points in pointlist P that fit the plane and are within
% TOL of a point already in the plane (oldlist)
function [newlist,remaining] = getallpoints(plane,oldlist,P,NP)

pnt = ones(4,1);
[N,~] = size(P);
%   oldlist = flipud(oldlist);
[Nold,~] = size(oldlist);
DISTTOL = 7; %15
tmpnewlist = zeros(NP,6);   
tmpnewlist(1:Nold,:) = oldlist;       % initialize fit list
tmpremaining = zeros(NP,6);           % initialize unfit list
countnew = Nold;
countrem = 0;
oldlist_center = mean(oldlist(:,1:3));
dist2center = max(sum(abs(oldlist(:,1:3) - repmat(oldlist_center, Nold,1)),2));
max_dist = (dist2center * 30);
%% Colour stuff
mean_val = mean(oldlist);
mean_colour = mean_val(4:6);

for i = 1 : N
    pnt(1:3) = P(i,1:3);
    pnt_rbg = P(i,4:6);
    notused = 1;
    % see if point lies in the plane
    if norm(oldlist_center - P(i,1:3)) < max_dist && abs(pnt'*plane) < DISTTOL  %&& (within_range(50, 50, mean_colour, pnt_rgb))
        % see if an existing nearby point already in the set
        countnew = countnew + 1;
        tmpnewlist(countnew,:) = P(i,:);
        notused = 0;
    end
    
    if notused
        countrem = countrem + 1;
        tmpremaining(countrem,:) = P(i,:);
    end
end

newlist = tmpnewlist(1:countnew,:);
remaining = tmpremaining(1:countrem,:);
countnew;
countrem;
Nold;

