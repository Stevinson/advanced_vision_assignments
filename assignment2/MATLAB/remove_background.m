function removed = remove_background(image, cleaned_image)
for i = 1:480 %% This changed to only test certain region - is this correct?
    for j = 1:639 %% This changed to only test certain region - is this correct?
        if cleaned_image(i,j)==0 %Invert
            cleaned_image(i,j)=1;
        else
            cleaned_image(i,j)=0;
        end
    end 
end
removed = imoverlay(image, cleaned_image, [0 0 0]);
end