%%
% Condensation tracker for one object.
%%

function [weights, trackstate, x, xc, oldsample] = track(person_identifier, number_of_frames, image_bg, colour, num_cond_samples, trackstate, x, xc, cc, cr, step, weights, oldsample, radius)

    %% Transition probabilities
    p_move = 0.4; %3
    p_stop = 0.4; %6
    p_collide = 0.2; %1
    p_move_gs = 0.5; p_stop_gs = 0.5;
    p_collide_gc = 1/3; p_move_gc = 2/3;

    %% Motion model matrices
    dt=1/9;
    A1=[[1,0,0,0]',[0,1,0,0]',[0,0,0,0]',[0,0,0,0]'];  % stopped
    A2=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]']; % moving
    A3=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]']; % collides

    [MR,MC,Dim] = size(image_bg);

    %% Condensation Tracking starts here
    if step ~= 1
        SAMPLE = 1000;
        ident = zeros(SAMPLE,1);
        idcount = 0;
        for newsample = 1 : num_cond_samples    
            % number of samples to generate
            num = floor(SAMPLE * weights(newsample,step-1, person_identifier));  
            if num > 0
                ident(idcount+1:idcount+num) = newsample * ones(1,num);
                idcount = idcount + num; 
            end
        end
    end

    %% generate new state vectors
    for newsample = 1 : num_cond_samples
        % sample randomly from the ident()
        if step == 1 
            % beginning state vector is random
            xc(:, person_identifier) = [floor(MC*rand(1)),floor(MR*rand(1)),0,0]';
        else
            % select which old sample
            while oldsample(person_identifier) == 0
                oldsample(person_identifier) = ident(ceil(1000*rand(1)));  
            end
            % get its state vector
            xc(:, person_identifier) = x(oldsample(person_identifier),step-1,:, person_identifier);  
        end

        %% hypothesize what state it will be in (deterministic dynamics) 
        % assume the person starts still (i.e. time = 1)
        if step == 1    
             xp = xc(:, person_identifier);   % no process at start
             A = A1;
             trackstate(newsample,step, person_identifier) = 1;
        % now for when time is not 1...
        else
            % create random probability for state selection
            r=rand(1); 
            if trackstate(oldsample(person_identifier), step-1, person_identifier) == 1
                %% if the person is stopped then can either stop or move
                % stopped having been stopped
                if r < p_stop_gs   
                    xc(3, person_identifier) = 0; % i.e. no velocity in x or y
                    xc(4, person_identifier) = 0;
                    A = A1;   
                    trackstate(newsample,step, person_identifier)=1;
                % going from stopped to moving
                else 
                    xc(3, person_identifier) = (normrnd(0,1)*300); 
                    xc(4, person_identifier) = (normrnd(0,1)*300);
                    A = A2; 
                    trackstate(newsample,step, person_identifier) = 2;
                end
            %% person collided in last state
            elseif trackstate(oldsample(person_identifier), step-1, person_identifier) == 3
                 % collides again
                 if r < p_collide_gc
                     A = A3; 
                     xc(3, person_identifier) = (normrnd(0,1)*30);
                     xc(4, person_identifier) = (normrnd(0,1)*30);
                 % goes to moving
                 else
                     A = A2; 
                     xc(3, person_identifier) = (normrnd(0,1)*300);
                     xc(4, person_identifier) = (normrnd(0,1)*300);
                 end 
            %% person was moving in last frame...     
            else
                % now stops...
                if r < p_stop
                    xc(3, person_identifier) = 0;
                    xc(4, person_identifier) = 0;
                    A = A3;
                % now moves...
                elseif r < (p_stop + p_move)
                    A = A2; 
                    %%
                    xc(3, person_identifier) = (normrnd(0,0.5)*300); 
                    xc(4, person_identifier) = (normrnd(0,0.5)*300); 
                    % I think if it just continues moving no values need setting?
                % now collides...
                else
                    A = A2; %Bu = Bu3;
                    xc(3, person_identifier) = (normrnd(0,1)*30); 
                    xc(4, person_identifier) = (normrnd(0,1)*30); 
                end
            end
        end
        %% Motion model: Update the state vector to get the next state vector
        xp = A * xc(:, person_identifier);      

    
        %% Now have predicted states we compare to observed states
        % update & evaluate new hypotheses
        x(newsample,step,:, person_identifier) = xp;
        % evaluate probability of observed image given data
        dvec = [cc(step, person_identifier),cr(step, person_identifier)] - [x(newsample,step,1, person_identifier),x(newsample,step,2, person_identifier)];
        weights(newsample,step, person_identifier) = 1 / (dvec * dvec'); 
  
    end
 
  % rescale new hypothesis weights
  totalw = sum(weights(:,step, person_identifier)'); 
  weights(:,step, person_identifier)=weights(:,step, person_identifier)/totalw;

  % select top hypothesis to draw
  subset = weights(:,step, person_identifier);
  top = find(subset == max(subset));
  trackstate(top,step, person_identifier);

  % display final top hypothesis
  figure(1)
  hold on
  %plot(x(top,step,1, person_identifier), x(top,step,2, person_identifier), [colour(person_identifier),'.']);
   for c = -0.99*radius(step,person_identifier): radius(step,person_identifier)/10 : 0.99*radius(step,person_identifier) 
         r = sqrt(radius(step,person_identifier)^2-c^2);
         plot(x(top,step,1, person_identifier)+c,x(top,step,2, person_identifier)+r,[colour(person_identifier), '.'])
         plot(x(top,step,1, person_identifier)+c,x(top,step,2, person_identifier)-r,[colour(person_identifier), '.'])
   end
  
end
