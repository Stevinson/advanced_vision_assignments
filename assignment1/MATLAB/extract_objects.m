%%
% Function that gets the objects from an image.
% Inputs:
%       - image: the image under question
%       - s_b: lightness of background
%       - sum_bg: R+G+B for background image
%       - sum_bg_norm: normlised R & G values for background image
%       - alpha & beta are threshold constants
%       - norm                                          !!!!!!!!!!!!
% Outputs:
%       - cleaned_image: boolean image with objects white
%       - ordered: 
%       - stats:
%       - labelled: 
%       - med: 
%%

function [cleaned_image, ordered, stats, labeled, med] = extract_objects(image, s_b, sum_bg, sum_bg_norm, alpha, beta, norm)
    
    % normalise image
    [sum, frame_norm] = normalise(image);
    % image lightness
    s_t = sum./3;
    
    %% Lightness and chromaticity tests
    BW = lightness_test(s_t, s_b, alpha, beta);
    BW2 = chromaticity_test(sum_bg_norm, frame_norm, alpha, beta);
    
    %% Combine the two tests
    image_tested = zeros(480,639);
    for i = 1:480
        for j = 1:639
            if BW(i,j)==1 || BW2(i,j)==1
                image_tested(i,j)=1;
            end
        end
    end
    
    %% Clean the image. Returns the cleaned image, !!!!
    [cleaned_image, labeled, med]  = clean_image(image_tested, image);

    %% Number the objects by size
    [ordered, stats] = size_split(cleaned_image);
    
    
end