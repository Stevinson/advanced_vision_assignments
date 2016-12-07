% Chromaticity test
% Only looks at the area we are interested in!
%%

function image_chromaticity = chromaticity_test(sum_bg_norm, frame_norm, alpha, beta)

    image_chromaticity = zeros(480,640);
    for i = 1:280 %% This changed to only test certain region - is this correct?
        for j = 300:600 %% This changed to only test certain region - is this correct?
         for k = 1:2
                 if frame_norm(i,j,k)/sum_bg_norm(i,j,k) < alpha || frame_norm(i,j,k)/sum_bg_norm(i,j,k) > beta             
                  image_chromaticity(i,j) = 1;
                 end
         end
        end
    end

end