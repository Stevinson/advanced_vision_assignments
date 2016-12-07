radius = 17;
colours = ['g.'; 'r.'; 'b.'; 'c.'];

% background frame
image_bg = imread('DATA1/bgframe.jpg','jpg'); 
% normalise background image
[sum_bg, sum_bg_norm] = normalise(image_bg);
% draw background image
imagesc(image_bg);
title('Trajectories of ground truths');


hold on
for frame_num = 1:210
    for i = 1:4
        cc = positions(i, frame_num,1); 
        cr = positions(i, frame_num,2); 
        hold on
        plot(cc, cr, [colours(i), '.']);
        pause(0.05)
    end
    
end


