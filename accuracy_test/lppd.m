clear all; clc
format long g

% Set LateX Interpreter
set(0,'defaultTextInterpreter','latex');
set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultLegendInterpreter','latex');

RSA_1024 = table2array(readtable('1024.txt'));
RSA_2048 = table2array(readtable('2048.txt'));
RSA_3072 = table2array(readtable('3072.txt'));
RSA_4096 = table2array(readtable('4096.txt'));

V = 15.11; %in Volt
I = 20; %mA

RSA_1024_EN = V*I*(RSA_1024(:,1))/1000;
RSA_2048_EN = V*I*(RSA_2048(:,1))/1000;
RSA_3072_EN = V*I*(RSA_3072(:,1))/1000;
RSA_4096_EN = V*I*(RSA_4096(:,1))/1000;


%% AR9300 chipset with 802.11b
%Chip Radio: % 3.3 Volt - TX: 296.970 mA , RX: 187.879 mA
TX_SPEED = 1000;
TX_VOLT  = 3.3;     %Voltage in V
TX_CURR  = 296.970; %Current in mA

% + 1 and + 4 are respectively the Key Index and the Timestamp
FRAME_RSA_1024 = ((14 + 20 + 8) + 6 + 1 + 1 + 12 + 128  + 4 + 2) + ((14 + 20 + 8) + 6 + 1 + 128 + 4 + 20 + 2); %14 bytes: MAC Header, 20 bytes: IP Header v4, 8: UDP
FRAME_RSA_2048 = ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 1 + 1 + 1 + 12 + 4 + 2) + ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 21 + 1 + 4 + 2);
FRAME_RSA_3072 = ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 129 + 1 + 12 + 1 + 4 + 2) + ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 149 + 1 + 4 + 2);
FRAME_RSA_4096 = ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 1 + 1 + 2 + 12 + 4 + 2) + ((14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 255 + 2 + (14 + 20 + 8) + 6 + 22 + 1 + 4 + 2);

TIME_TX_RSA_1024 = (FRAME_RSA_1024*8)/TX_SPEED; %Time in milliseconds - (https://www.vcalc.com/wiki/JustinLiller/Transmission+Delay)
TIME_TX_RSA_2048 = (FRAME_RSA_2048*8)/TX_SPEED; %Time in milliseconds - (https://www.vcalc.com/wiki/JustinLiller/Transmission+Delay)
TIME_TX_RSA_3072 = (FRAME_RSA_3072*8)/TX_SPEED; %Time in milliseconds - (https://www.vcalc.com/wiki/JustinLiller/Transmission+Delay)
TIME_TX_RSA_4096 = (FRAME_RSA_4096*8)/TX_SPEED; %Time in milliseconds - (https://www.vcalc.com/wiki/JustinLiller/Transmission+Delay)

EN_TX_RSA_1024  = (TX_VOLT*TX_CURR*TIME_TX_RSA_1024)/1000;
EN_TX_RSA_2048  = (TX_VOLT*TX_CURR*TIME_TX_RSA_2048)/1000;
EN_TX_RSA_3072  = (TX_VOLT*TX_CURR*TIME_TX_RSA_3072)/1000;
EN_TX_RSA_4096  = (TX_VOLT*TX_CURR*TIME_TX_RSA_4096)/1000;

%% Timings
fig = figure(1);
hold on
grid on

N = size(RSA_1024(:,1),1);
yMean = mean(RSA_1024(:,1));                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_1024(:,1))/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(1, [TIME_TX_RSA_1024 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(1,sum([TIME_TX_RSA_1024 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

N = size(RSA_2048(:,1),1);
yMean = mean(RSA_2048(:,1));                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_2048(:,1))/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(2, [TIME_TX_RSA_2048 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(2,sum([TIME_TX_RSA_2048 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

N = size(RSA_3072(:,1),1);
yMean = mean(RSA_3072(:,1));                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_3072(:,1))/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(3, [TIME_TX_RSA_3072 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(3,sum([TIME_TX_RSA_3072 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');


N = size(RSA_4096(:,1),1);
yMean = mean(RSA_4096(:,1));                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_4096(:,1))/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(4, [TIME_TX_RSA_4096 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(4,sum([TIME_TX_RSA_4096 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

ax = gca;
set(gca,'box','on');
%ax.XTick = [1.25 2.25 3.25 4.25 5.25];
ax.XTick = [1 2 3 4];
ax.YTick = [10.^(1:3)];
ax.XTickLabel = {'$1024$', '$2048$', '$3072$', '$4096$'};
xlabel('RSA Key Size [bit]')
legend('Radio','Computations + Radio', 'FontSize',26, 'Location', 'northwest', 'Orientation','vertical');
set(get(fig,'CurrentAxes'),'GridAlpha',1,'MinorGridAlpha',1);
set(gca, 'FontSize',28);
%xtickangle(30);
ylabel('Time [$ms$]');
set(ax, 'YScale', 'log');
ylim([1 2500]);
orient(fig, 'landscape');
print(fig, '-bestfit', 'time','-dpdf');

%% Energy
fig = figure(2);
hold on
grid on

N = size(RSA_1024_EN,1);
yMean = mean(RSA_1024_EN);                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_1024_EN)/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(1, [EN_TX_RSA_1024 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(1,sum([EN_TX_RSA_1024 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');


N = size(RSA_2048_EN,1);
yMean = mean(RSA_2048_EN);                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_2048_EN)/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(2, [EN_TX_RSA_2048 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(2,sum([EN_TX_RSA_2048 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

N = size(RSA_3072_EN,1);
yMean = mean(RSA_3072_EN);                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_3072_EN)/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(3, [EN_TX_RSA_3072 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(3,sum([EN_TX_RSA_3072 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

N = size(RSA_4096_EN,1);
yMean = mean(RSA_4096_EN);                                      % Mean Of All Experiments At Each Value Of ‘x’
ySEM = std(RSA_4096_EN)/sqrt(N);                                % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95 = tinv([0.025 0.975], N-1);                        % Calculate 95% Probability Intervals Of t-Distribution
yCI95 = bsxfun(@times, ySEM, CI95(:));                  % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

b = bar(4, [EN_TX_RSA_4096 yMean], 0.4, 'stacked');
b(1).FaceColor = [0.9 0.9 0.9];
b(2).FaceColor = [0.55 0.55 0.55];
errorbar(4,sum([EN_TX_RSA_4096 yMean]),yCI95(1),yCI95(2), 'LineWidth', 1.5, 'Color', 'r');

ax = gca;
set(gca,'box','on');
%ax.XTick = [1.25 2.25 3.25 4.25 5.25];
ax.XTick = [1 2 3 4];
ax.YTick = [10.^(1:3)];
set(get(fig,'CurrentAxes'),'GridAlpha',1,'MinorGridAlpha',1);
ax.XTickLabel = {'$1024$', '$2048$', '$3072$', '$4096$'};
xlabel('RSA Key Size [bit]')
legend('Radio','Computations + Radio', 'FontSize',26, 'Location', 'northwest', 'Orientation','vertical');
set(gca, 'FontSize',28);
%xtickangle(30);
ylabel('Energy [$mJ$]');
set(ax, 'YScale', 'log');
ylim([1 1000]);
orient(fig, 'landscape');
print(fig, '-bestfit', 'energy','-dpdf');

%% MAVLink Messages
fig = figure(3);
hold on
grid on

b = bar(1, [2], 0.4);
b(1).FaceColor = [0.55 0.55 0.55];
b = bar(2, [4], 0.4);
b(1).FaceColor = [0.55 0.55 0.55];
b = bar(3, [4], 0.4);
b(1).FaceColor = [0.55 0.55 0.55];
b = bar(4, [6], 0.4);
b(1).FaceColor = [0.55 0.55 0.55];

ax = gca;
set(gca,'box','on');
ax.XTick = [1 2 3 4];
ax.YTick = [1:6];
set(get(fig,'CurrentAxes'),'GridAlpha',1,'MinorGridAlpha',1);
ax.XTickLabel = {'$1024$', '$2048$', '$3072$', '$4096$'};
legend('UAV $u_\alpha$ + UAV $u_\beta$', 'FontSize',26, 'Location', 'northwest', 'Orientation','vertical','Interpreter','latex');
xlabel('RSA Key Size [bit]')
set(gca, 'FontSize',28);
%xtickangle(30);
ylabel('MAVLink Messages [\#]');
ylim([1 6]);
orient(fig, 'landscape');
print(fig, '-bestfit', 'messages','-dpdf');

%% Operations
fig = figure(4);
hold on
grid on
BN_mod_mul_1024 = table2array(readtable('BN_mod_mul_1024.txt'));
BN_mod_mul_2048 = table2array(readtable('BN_mod_mul_2048.txt'));
BN_mod_mul_3072 = table2array(readtable('BN_mod_mul_3072.txt'));
BN_mod_mul_4096 = table2array(readtable('BN_mod_mul_4096.txt'));

BN_mod_div_1024 = table2array(readtable('BN_mod_div_1024.txt'));
BN_mod_div_2048 = table2array(readtable('BN_mod_div_2048.txt'));
BN_mod_div_3072 = table2array(readtable('BN_mod_div_3072.txt'));
BN_mod_div_4096 = table2array(readtable('BN_mod_div_4096.txt'));

BN_mod_exp_1024 = table2array(readtable('BN_mod_exp_1024.txt'));
BN_mod_exp_2048 = table2array(readtable('BN_mod_exp_2048.txt'));
BN_mod_exp_3072 = table2array(readtable('BN_mod_exp_3072.txt'));
BN_mod_exp_4096 = table2array(readtable('BN_mod_exp_4096.txt'));


data = [BN_mod_mul_1024, BN_mod_mul_2048, BN_mod_mul_3072, BN_mod_mul_4096, BN_mod_div_1024, BN_mod_div_2048, BN_mod_div_3072, BN_mod_div_4096, BN_mod_exp_1024, BN_mod_exp_2048, BN_mod_exp_3072, BN_mod_exp_4096];

N = size(data,1);
x       = 1:N;
durMean = mean(data);
durSEM  = std(data)/sqrt(N);                        % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
CI95    = tinv([0.025 0.975], N-1);                % Calculate 95% Probability Intervals Of t-Distribution
yCI95   = bsxfun(@times, durSEM, CI95(:));         % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’

model_series = [durMean(1,1:4);durMean(1,5:8);durMean(1,9:12)];
model_error = [yCI95(2,1:4); yCI95(2,5:8); yCI95(2,9:12)];

ax = gca();
b = bar(model_series, 'grouped');
set(b(1), 'FaceColor', [0.9 0.9 0.9]);
set(b(2), 'FaceColor', [0.75 0.75 0.75]);
set(b(3), 'FaceColor', [0.55 0.55 0.55]);
set(b(4), 'FaceColor', [0 0 0]);
%%For MATLAB R2019a or earlier releases
hold on
grid on
ngroups = size(model_series, 1);
nbars = size(model_series, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));

for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    h = errorbar(x, model_series(:,i), model_error(:,i), 'r', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(model_series, 2);
% Get the x coordinate of the bars
x = [];
for i = 1:nbars
    x = [x ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x',model_series,model_error,'Color','r', 'LineWidth', 1.5, 'LineStyle', 'none', 'CapSize', 10);

xticks([1 2 3]);
xticklabels({'\texttt{Mod. MUL}', '\texttt{Mod. DIV}', '\texttt{Mod. EXP}'});
set(gca,'box','on');
lgd = legend('$1024$', '$2048$', '$3072$', '$4096$', 'Location', 'northwest', 'FontSize', 26);
title(lgd,"RSA Modulus");
ylabel('Operations');
ylabel('Average Time [$ms$]');
ylim([0.001 1100]);
yticks([0.01 0.1 1 10 100 1000]);
%xtickangle(30);
set(gca, 'FontSize',28);
set(ax,...
    'YScale','log');
orient(fig, 'landscape');
print(fig, '-bestfit', 'mis_rsa','-dpdf');