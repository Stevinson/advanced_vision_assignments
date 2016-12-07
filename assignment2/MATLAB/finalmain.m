%%
% Main file for condensation tracker using ground truths.
%%
% Clear all figures
delete(findall(0,'Type','figure'))
%med_prev_image = zeros(1,480,640,3);
%% Detection constants
alpha = 0.75;
beta = 1.35;
colour = ['r','w','b','y']; 
NUM_PEOPLE = 4;
% Define eval matrix 210 frames, 4 people, 2 co-ords
%eval_matrix = zeros(210,4,2);

%% Condensation tracker initialisation
num_cond_samples = 3000;          % number of condensation samples
num_people = 4;
num_frames = 210;
number_of_frames = 210;
num_states = 4; % number of states: x_pos, y_pos, x_vel, y_vel
x = zeros(num_cond_samples,num_frames,num_states, num_people);      % state vectors
weights = zeros(num_cond_samples,num_frames, num_people);  % est. probability of state
trackstate = zeros(num_cond_samples,num_frames, num_people);   % 1,2,3,4 = x_pos, y_pos, x_vel, y_vel      
oldsample = zeros(num_people,1); 
xc = zeros(4,num_people); % initialise selected state

%% Load and normalise background frame
% background frame
image_bg = imread('DATA1/bgframe.jpg','jpg'); 
% normalise background image
[sum_bg, sum_bg_norm] = normalise(image_bg);
% lightness values (lightness background = s_b)
s_b = sum_bg./3;
% Make size of for loop, for speed, for robust mean component size
medi = zeros([30,1]);
% Make size of for loop, for speed, to check number of labels 
labeleds = zeros([30,1]);
lab = [];
%Boolean check for if the first loop
bool = 0;
%imagesc(image_bg);

%% Loop through each frame
for step = 1 : 210
    % Labels matrix
    lab = ones(NUM_PEOPLE);
    %Distance Matrix
    dist_matrix = ones(NUM_PEOPLE);
    lab1d = [];
    
    %% Load current image
    % read current frame
    image = imread(['DATA1/frame',int2str(step+109), '.jpg'],'jpg');
    % background subtraction, image cleaning, and statistics of objects
    [cleaned_image, ordered, stats, labeled, med] = extract_objects(image, s_b, sum_bg, sum_bg_norm, alpha, beta);
  
    % Median, as we keep getting noise, so do one run to see robust median of regions (we've seen more people than noise on average).
    % Adjust array to ensure we have correct median
    medi(step) = med;
    %Label array so we can ensure no noisy labels have been made
    labeleds(step) = max(max(labeled));
    
    %Make median holder
    %prev_image = zeros(210,480,640,3);
    
   %Check if first frame!
     if(bool == 0)
         bool = 1;
         %Save frame labels
         first_labels = labeled;
        %Save Regions of First Image
        first_stats = stats;
        prev_stats = stats;
        %First image
        first_image = image;
        prev_image(step,:,:,:) = image;
        %Update this part to num_people
        %lab = lab + [0, 10, 10, 10; 10,0,10,10; 10,10,0,10; 10,10,10,0];
        % update order labels
        %updated_labels = minmin(lab);
        updated_labels = [1; 2; 3; 4];
    else 
         cur_image = image;
         % These don't matter which order as should be same size....
         %      - UNLESS we fucked up.....
         for reg = 1:size(stats)
             templab = [];
             for reg2 = 1:size(prev_stats)
                 %% For Euclidean Distance, take stats and prev stats
                 %dist_matrix(reg,reg2) = eD(stats(reg).Centroid,prev_stats(reg2).Centroid);
                 %% For RGB Distance
                 x_s = prev_stats(reg2);
                 x_radius = 0.9*sqrt(x_s.Area/pi);
                 x_start = x_s.Centroid(1) - x_radius;
                 y_start = x_s.Centroid(2) - x_radius;
                 x_length = 2*x_radius;
                 y_length = 2*x_radius;
                 % Median of previous images]
                 % med_prev_images(1,:,:,:) = median(prev_image(1:step-1,:,:,:),1);
                 % Make our own bounding box
                 %cropped1 = imcrop(squeeze(med_prev_image),[x_start, y_start, x_length, y_length]);
                 x_s = stats(reg);
                 x_radius = 0.9*sqrt(x_s.Area/pi);
                 x_start = x_s.Centroid(1) - x_radius;
                 y_start = x_s.Centroid(2) - x_radius;
                 x_length = 2*x_radius;
                 y_length = 2*x_radius;
                 % Make our own bounding box  
                 %cropped2 = imcrop(cur_image,[x_start, y_start, x_length, y_length]);
                 lab(reg,reg2) = (eD(stats(reg).Centroid,prev_stats(reg2).Centroid)); % + 2*hist(cropped1,cropped2);    
             end
         end
         
         updated_labels = minmin(lab);
end
    % Keep for next frame analysis
    prev_stats = stats ; % needs reordering
    prev_image(step,:,:,:) = image;
    
    %% Display the cleaned image
    %imagesc(cleaned_image); title(['cleaned image' num2str(i)]); colormap(gray);
    imagesc(image); title(['cleaned image' num2str(i)]);
    
    % Get CoM, radius and ... and then draw circles
   % NUM = size(ordered);
    %lab;
    %% Use detections as observed data...
    for j = 1:4    
        % get center of mass and radius of 2 largest
         %cc(step, j) = stats(updated_labels(j)).Centroid(1);
         %cr(step, j) = stats(updated_labels(j)).Centroid(2);
         %radius(step,j) = sqrt(stats(updated_labels(j)).Area/pi);
     end
    %% Use ground truths for observations (with fixed radius)... 
     for person_number = 1:4
         cc(step, person_number) = positions(person_number,step,1);
         cr(step, person_number) = positions(person_number,step,2);
         radius(step, person_number) = 14;
     
     %% draw circles around detected objects
        hold on;
        for  c = -0.97*radius(step,person_number): radius(step,person_number)/20 : 0.97*radius(step,person_number)
            r = sqrt(radius(step, person_number)^2-c^2);
            plot(cc(step, person_number) +c,cr(step, person_number) +r,'g.')
            plot(cc(step,person_number)+c,cr(step,person_number)-r,'g.')
        end
        str = sprintf('Frame %d', step);
        title(str);
     end
    
    %% Tracking
    % If there exists the label A in the label matrix ...
        % Then use tracker on that label ...
        [weights, trackstate, x, xc, oldsample] = track(1, number_of_frames, image_bg, colour, num_cond_samples, trackstate, x, xc, cc, cr, step, weights, oldsample, radius);
        [weights, trackstate, x, xc, oldsample] = track(2, number_of_frames, image_bg, colour, num_cond_samples, trackstate, x, xc, cc, cr, step, weights, oldsample, radius);
        [weights, trackstate, x, xc, oldsample] = track(3, number_of_frames, image_bg, colour, num_cond_samples, trackstate, x, xc, cc, cr, step, weights, oldsample, radius);
        [weights, trackstate, x, xc, oldsample] = track(4, number_of_frames, image_bg, colour, num_cond_samples, trackstate, x, xc, cc, cr, step, weights, oldsample, radius);
    % Pause between frames
    pause(0.01)
%     %% Rearrange
%      newstructure = stats;
%      for i = 1:4
%          a = find(updated_labels == i);
% %         %newstructure(i) = stats(a);
%          prev_stats(i) = newstructure(a);
%      end
end