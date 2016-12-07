%%
% Lightness test
%%

function image_lightness = lightness_test(s_t, s_b, alpha, beta)
    
    image_lightness = zeros(480,640);
    for i = 1:280 %% This changed to only test certain region - is this correct?
        for j = 300:600 %% This changed to only test certain region - is this correct?
         if s_t(i,j)/s_b(i,j)<alpha || s_t(i,j)/s_b(i,j)>beta
              image_lightness(i,j) = 1;
         end
        end 
    end
    
end