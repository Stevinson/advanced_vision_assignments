% Compute normalised histograms
%%

function bhattacharyyaDistance = hist(cropped1, cropped2)
    [r1, g1, b1] = rgbhist(cropped1,0,1);
    [r2, g2, b2] = rgbhist(cropped2,0 ,1);

    %% concat 3 channels into single histograms

    hist1 = [r1' g1' ];
    hist2 = [r2' g2' ];

    %% normalise from concat
    hist1 = hist1./2;
    hist2 = hist2./2;
    
    %% compute comparison statistics

    bhattacharyyaDistance = bhattacharyya(hist1, hist2);



%     %% plot images and RGB histograms
% 
%     axisYmax = max(max(r1), max(max(g1)));
%     axisYmax = max(axisYmax, max(max(r2), max(max(g2))));
% 
%     figure(1);
%     set(1, 'Name', 'RGB Histogram Comparison');
%     subplot(2, 2, 1);
%     imshow(cropped1);
%     xlabel('RGB Image 1');
% 
%     subplot(2, 2, 2);
%     hold on
%     plot(r1, 'red')
%     plot(g1, 'green')
%     axis([0, 256, 0, axisYmax])
%     xlabel('RGB Image 1 - normalised RGB histogram');
% 
%     subplot(2, 2, 3);
%     imshow(cropped2);
%     xlabel('RGB Image 2');
% 
%     subplot(2, 2, 4);
%     hold on
%     plot(r2, 'red')
%     plot(g2, 'green')
%     axis([0, 256, 0, axisYmax])
%     xlabel('RGB Image 2 - normalised RGB histogram');

end