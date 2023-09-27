clear;
format long g;
rng(0, 'twister');
seed=0;

seed = seed + 1;
lppd_accuracy(seed);
%ppo

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

seed = seed + 1;
lppd_accuracy(seed);

tot_collisions_ext=zeros(1,10);
ext_index = 0;

load lppd_accuracy_1
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_2
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_3
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_4
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_5
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_6
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_7
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_8
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_9
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

load lppd_accuracy_10
ext_index=ext_index+1; perc_collisions_tot(ext_index,:) = perc_collisions; tot_collisions_ext(ext_index) = tot_collisions;

mean_perc_collisions = mean(perc_collisions_tot,1);
%NUM_R = 7;
conf_int = zeros(NUM_R,2);
for i=1:NUM_R
    conf_int(i,:) = my_confidence_interval(perc_collisions_tot(:,i), 0.975);
    confidence(i) = conf_int(i,2) - conf_int(i,1);
end

save lppd_accuracy_data_new_2
%ppo
clc
clear all

% Set LateX Interpreter
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultLegendInterpreter','latex');

load lppd_accuracy_data_new_2

fig = figure(1);
%plot(R_VECT, mean_perc_collisions, 'LineWidth', 3, 'Color', 'black');
errorbar([0; R_VECT(:,1)]', [0 mean_perc_collisions], [0,confidence], 'LineWidth', 3, 'Color', 'black');
%errorbar(R_VECT, mean_perc_collisions, confidence, 'LineWidth', 3, 'Color', 'black');
xlim([0 6]);
ylim([0 1]);
ylabel('Proximity Detection Ratio');
xlabel('Sphere Radius [$m$]');
grid on;
x1 = xline(R_min(1),'-r', {'$r_{\alpha}$'}, 'LabelHorizontalAlignment', 'center', 'LabelVerticalAlignment', 'middle', 'Interpreter' , 'latex',  'LineWidth', 3);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
x1.LabelOrientation = 'horizontal';
x1.FontSize = 28;
set(gca, 'Fontsize', 28);
orient(fig, 'landscape');
print(fig, '-bestfit', 'avoidance_test','-dpdf');