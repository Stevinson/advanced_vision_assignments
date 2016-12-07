% Function which takes an image, cleans it, and returns the cleaned version
% and a labelled version
% Outputs:
%       - cleaned image: boolean image with objects white
%%

function [cleaned_image, labelled_image2, med] = clean_image(image, norm)

    %% Clean up the image
    % create structuring elements
    structuring_elem = strel('square',12);
    structuring_elem2 = strel('square',3);
    structuring_elem3 = strel('diamond',2);
    structuring_elem4 = strel('diamond',5);
    
    BW2 = image;
    %% Erode to remove spurs
    eroded_image = imerode(BW2,structuring_elem3);
    %imagesc(eroded_image); title('eroded1 image'); colormap(gray); figure;

    %% Dilate to fill internal holes
    dilated_image = imdilate(eroded_image,structuring_elem);
    %dilated_image = imclose(eroded_image,structuring_elem);
    %imagesc(dilated_image); title('dilated image'); colormap(gray); figure;

    %% Erode to restore size
    eroded_image2 = imerode(dilated_image,structuring_elem2);
    %imagesc(eroded_image2); title('Eroded image 2'); colormap(gray); figure;

    %% Collect into regions
    connected_regions2 = bwconncomp(eroded_image2,8);
    
    % get area of connected regions
    regions2 = regionprops(connected_regions2, 'Area', 'PixelIdxList', ...
            'BoundingBox','MajorAxisLength','MinorAxisLength');
    
    %%
    %Used robust mean to give good estimate to cut out noise
    % Return so we can get overall median to use as a estimator.
    med = median([regions2.Area]);
    
    %%
    % label each region
    labelled_image2 = labelmatrix(connected_regions2);
    % remove regions with less than 'x' pixels
    cleaned_image = ismember(labelled_image2, find([regions2.Area] >= 350));
    %Take 2
    connected_regions2 = bwconncomp(cleaned_image,8);
    % get area of connected regions
    regions2 = regionprops(connected_regions2, 'Area', 'PixelIdxList', ...
            'BoundingBox','MajorAxisLength','MinorAxisLength', 'Orientation' ...
            ,'Centroid');
    %% Tried using a Sobel Filter to seperate 
%     sz = size(regions2);
%     for i = 1:sz
%      if regions2(i).Area > 1000 & regions2(i).MajorAxisLength > 20
%         %Get the centroids x
%         centx = regions2(i).Centroid(1);
%         %Get the centroids y
%         centy = regions2(i).Centroid(2); 
%         theta = regions2(i).Orientation; 
%         majorAxis = (regions2(i).MajorAxisLength/4.);
%         regions2(i).Centroid(1) = centx + (majorAxis*cos(theta)) + ...
%                                     (majorAxis*sin(theta));
%         regions2(i).Centroid(2) = centy + (majorAxis*cos(theta)) + ...
%                                     (majorAxis*sin(theta));
%         regions2(end+1).Centroid(1) = centx - (majorAxis*cos(theta)) - ...
%                                     (majorAxis*sin(theta));
%         regions2(end+1).Centroid(2) = centy + (majorAxis*cos(theta)) + ...
%                                     (majorAxis*sin(theta));
%      end
%     end






%          crop = imcrop(norm, regions2(i).BoundingBox);
%         I = rgb2gray(crop);
%         [~, threshold] = edge(I, 'sobel');
%         fudgeFactor = .5;
%         BWs = edge(I,'sobel', threshold * fudgeFactor);
%         %figure, imshow(BWs), title('binary gradient mask');
%         se90 = strel('line', 3, 90);
%         se0 = strel('line', 3, 0);
%         BWsdil = imdilate(BWs, [se90 se0]);
%         %figure, imshow(BWsdil), title('dilated gradient mask');
%         BWdfill = imfill(BWsdil, 'holes');
%         %figure, imshow(BWdfill), title('fill mask');
%         BWdfill = imerode(BWdfill, structuring_elem4);
%         %imshow(BWdfill), title('ERODED');figure;
%         %% Collect into regions
%         connected_regions2 = bwconncomp(BWdfill,8);
% 
%         % get area of connected regions
%         regions3 = regionprops(connected_regions2, 'Area', 'PixelIdxList', ...
%                 'BoundingBox','MajorAxisLength','MinorAxisLength');
%         %%
%         % label each region
%         labelled_image2 = labelmatrix(connected_regions2);
%         % remove regions with less than 'x' pixels
%         BWdfill = ismember(labelled_image2, find([regions3.Area] >= 25));
%         bw = bwlabel(BWdfill);
%         b1 = round(regions2(1).BoundingBox(1));
%         b2 = round(regions2(1).BoundingBox(2));
%         b3 = regions2(1).BoundingBox(3);
%         b4 = regions2(1).BoundingBox(4);
%         
%         imshow(BWdfill);figure;
%         %Calculate centroid in terms of actual image
%         
%         %%
%         % label each region
%         labelled_image2 = labelmatrix(connected_regions2);
%    end
end