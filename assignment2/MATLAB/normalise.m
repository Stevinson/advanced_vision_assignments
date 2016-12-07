%% Function to normalise the image frame
function [sum, sum_norm] = normalise(frame)

    %% normalise image
    % change them from uint8 to double type
    frame_asdouble = cast(frame, 'double');
    frame_size = size(frame);
    % sum red, green & blue pixels
    sum = frame_asdouble(:,:,1) + frame_asdouble(:,:,2) + frame_asdouble(:,:,3);
    % create normalised matrix
    sum_norm = zeros(frame_size(1),frame_size(2),2);
    sum_norm(:,:,1) = frame_asdouble(:,:,1) ./ sum;
    sum_norm(:,:,2) = frame_asdouble(:,:,2) ./ sum;
    
end