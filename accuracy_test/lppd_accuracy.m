function [outputArg1,outputArg2] = lppd_accuracy(seed)

    %%% Script for simulation of no collisions between drones using LPPD
    %clear;
    format long g;

    T_p = 0.02; %seconds, time to run a LPPD instance
    V_max = 20.88; %13.88; %m/s, equivalent to 50 Km/h, max speed of a drone in LPPD

    NUM_ITERATIONS = 1000; % number of tests

    NUM_STEPS = 100; % Number of steps to evaluate in the simulation, in seconds

    % Generate NUM_DRONES random positions
    NUM_DRONES = 100;  %Number of drones in the scenario

    SIZE_XY = 50; % meters
    SIZE_Z = 120; %meters
    
    eps_x = 3; %meters, maximum uncertainty of x coordinate
    eps_y = 3; %meters, maximum uncertainty of y coordinate
    eps_z = 3; %meters, maximum uncertainty of z coordinate

    %seed=1;
    rng(seed,'twister');
    x_D_true = SIZE_XY * randraw('uniform',[0,1],NUM_ITERATIONS,NUM_DRONES); %meters
    err_x = eps_x * randraw('uniform',[-1,1],NUM_ITERATIONS,NUM_DRONES); %meters
    x_D = x_D_true + err_x;

    rng(seed*10+1,'twister');
    y_D_true = SIZE_XY * randraw('uniform',[0,1],NUM_ITERATIONS,NUM_DRONES); %meters
    err_y = eps_y * randraw('uniform',[-1,1],NUM_ITERATIONS,NUM_DRONES); %meters
    y_D = y_D_true + err_y;

    rng(seed*10+2,'twister');
    z_D_true = SIZE_Z * randraw('uniform',[0,1],NUM_ITERATIONS,NUM_DRONES); %meters
    err_z = eps_z * randraw('uniform',[-1,1],NUM_ITERATIONS,NUM_DRONES); %meters
    z_D = z_D_true + err_z;

    %x_D = [2.5, 75.3]; % x-coordinate of the drones in the scenario
    %y_D = [2.7, 65.1]; % y-coordinate of the drones in the scenario
    %z_D = [25.1, 25.1]; % z-coordinate of the drones in the scenario

    % Generate NUM_STEPS velocity vectors for each of the drones
    rng(3,'twister');
    V0_mod = V_max * randraw('uniform',[0,1],NUM_ITERATIONS,NUM_DRONES); %meters

    rng(52,'twister');
    V0_theta = randraw('uniform',[-pi,pi],NUM_ITERATIONS,NUM_DRONES); % angle
    rng(31,'twister');
    V0_phi = randraw('uniform',[-pi,pi],NUM_ITERATIONS,NUM_DRONES); % elevation

    V0_x = V0_mod .* cos(V0_theta) .* cos(V0_phi);
    V0_y = V0_mod .* sin(V0_theta) .* cos(V0_phi);
    V0_z = V0_mod .* sin(V0_phi);

    G = 5 * ones(1,NUM_DRONES); %m, guard space of each drone in LPPD
    
    epsilon_xyz_t = sqrt(eps_x^2 + eps_y^2 + eps_z^2)/2; %meters, maximum uncertainty of the GPS position
    epsilon_xyz = eps_x/8;%sqrt(3)/2 * eps_z;
    %R_min = V_max * (T + T_p) + G - G; % meters, Radius selected by each
    %drone in LPPD
    R_minimum = V_max * (T_p) + G + epsilon_xyz; % meters, Radius selected by each drone in LPPD
    %R_min(1)
    %R_VECT = [G; R_minimum./9; R_minimum./7; R_minimum./6; R_minimum./5; R_minimum./4; R_minimum./3; R_minimum/2; R_minimum];
    %R_VECT_t = [G(1), G(1) + 0.5, (G(1)+1):1:R_minimum(1)-1, R_minimum(1)];
    %R_VECT_t = [G(1), G(1) + 0.5, (G(1)+1), R_minimum(1)];
    R_VECT_t = [G(1), G(1) + 0.25, G(1) + 0.5, R_minimum(1)];
    R_VECT = (R_VECT_t.*ones(NUM_DRONES,1))';
    %ppo
    
    NUM_R = size(R_VECT,1);
    %ppo

    perc_collisions = zeros(1,NUM_R);
    det_collisions_iter = zeros(NUM_R, NUM_ITERATIONS);
    tot_collisions_iter = zeros(NUM_R, NUM_ITERATIONS);

    for r_it = 1:NUM_R

        tot_collisions = 0;
        det_collisions = 0;
        R_min = R_VECT(r_it, :);

        %ppo

        % each T, we evaluate if a couple of drones are too close each other
        for it_iter = 1:NUM_ITERATIONS

            % particular iteration it_iter
            x_i = x_D(it_iter,:);
            y_i = y_D(it_iter,:);
            z_i = z_D(it_iter,:);

            % check if the random start positions are too close
            for j=1:NUM_DRONES
                    for k=j+1:NUM_DRONES
                        
%                         if r_it == NUM_R && it_iter == 11 & j==6 && k==36
%                             it_iter
%                         end
                        dist_jk = sqrt( (x_i(j) - x_i(k))^2 + (y_i(j) - y_i(k))^2 + (z_i(j) - z_i(k))^2 );

                        if dist_jk <= R_min(j)                            
                            % extract new position for k
                            coll_fut = 1;
                            while coll_fut == 1

                                x_i(j) = SIZE_XY * randraw('uniform',[0,1],1,1); %meters;
                                y_i(j) = SIZE_XY * randraw('uniform',[0,1],1,1); %meters;
                                z_i(j) = SIZE_Z * randraw('uniform',[0,1],1,1); %meters;

                                coll_fut = 0;
                                for kk=[1:j-1,j+1:NUM_DRONES]
                                    dist_jkk = sqrt( (x_i(j) - x_i(kk))^2 + (y_i(j) - y_i(kk))^2 + (z_i(j) - z_i(kk))^2 );

                                    if dist_jkk <= R_min(j)
                                        coll_fut = 1;
                                    end
                                end
                            end
                        end
                    end
            end

            %ppo

        %     figure();
        %     for k=1:NUM_DRONES
        %         plot(x_D(k), y_D(k), 'o', 'Color', 'blue');
        %         hold on
        %     end

            det_collisions_iter(r_it, it_iter) = 0;
            tot_collisions_iter(r_it, it_iter) = 0;

            for i=1:1:NUM_STEPS
                % particular step in the simulation
                %i
                
%                 if i==1 && it_iter == 11 && r_it==NUM_R
%                     i      
%                     x_i(6)
%                     x_i(36)
%                     y_i(6)
%                     y_i(36)
%                     z_i(6)
%                     z_i(36)
%                     
%                 end

                % move drones to new position
                x_i = x_i + V0_x(it_iter,:) .* (T_p);
                y_i = y_i + V0_y(it_iter,:) .* (T_p);
                z_i = z_i + V0_z(it_iter,:) .* (T_p);

                % vector for new positions (updated at the end)
                xn_i = x_i;
                yn_i = y_i;
                zn_i = z_i;

        %         for k=1:NUM_DRONES
        %             plot(x_i(k), y_i(k), 'o', 'Color', 'red');
        %             hold on
        %         end

                % evaluate collision according to our tessellation logic
                for j=1:NUM_DRONES
                    for k=j+1:NUM_DRONES
                        dist_jk = sqrt( (xn_i(j) - xn_i(k))^2 + (yn_i(j) - yn_i(k))^2 + (zn_i(j) - zn_i(k))^2 );
                        
%                         if j==6 && k==36 && i==1 && it_iter == 11 && r_it==NUM_R
%                             j                            
%                         end

                        if dist_jk < R_min(j)
                            %dist_jk
                            %disp('Proximity Detected');
                            tot_collisions = tot_collisions + 1;
                            tot_collisions_iter(r_it, it_iter) = tot_collisions_iter(r_it, it_iter)+1;
                            if dist_jk > G(j)
                                %disp ('Collision Avoided');
        %                             for k1=1:NUM_DRONES
        %                                 plot(x_i(k1), y_i(k1), 'o');
        %                                 hold on
        %                             end
                                %ppo
                                
%                                 if i==1 && r_it==NUM_R
%                                     it_iter
%                                     
%                                 end

                                % report the detected collision
                                det_collisions = det_collisions + 1;
                                det_collisions_iter(r_it, it_iter) = det_collisions_iter(r_it, it_iter) + 1;

                                % take countermeasure
                                                             
                                coll_fut = 1;
                                while coll_fut == 1
                                    
                                    %K_FACT = 5
                                    xn_i(j) = SIZE_XY * randraw('uniform',[0,1],1,1); %meters;
                                    yn_i(j) = SIZE_XY * randraw('uniform',[0,1],1,1); %meters;
                                    zn_i(j) = SIZE_Z * randraw('uniform',[0,1],1,1); %meters;
                                    
                                    coll_fut = 0;
                                    for kk=[1:j-1,j+1:NUM_DRONES]
                                        dist_jkk = sqrt( (xn_i(j) - xn_i(kk))^2 + (yn_i(j) - yn_i(kk))^2 + (zn_i(j) - zn_i(kk))^2 );
                                        
                                        if dist_jkk <= R_min(j)
                                            coll_fut = 1;
                                        end
                                    end
                                end
                                
                                
                            else
                                % boooooooooooom!
                                %disp ('Collision NOT Avoided');
                                if r_it == NUM_R
                                    r_it
                                    %ppo
                                end
                                %ppo
                            end

                        else
                            % proximity not detected, update position regularly
                            %disp('Far UAVs');
                        end
                    end
                end

                % update position
                x_i = xn_i;
                y_i = yn_i;
                z_i = zn_i;

            end
            % out of the steps in each iteration

            %ppo

        end

        perc_collisions(r_it) = det_collisions/tot_collisions;
        perc_collisions(r_it)
    end

    filename = strcat({'lppd_accuracy_'}, num2str(seed));
    save(char(filename))

end



