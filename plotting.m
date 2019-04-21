clc; clear; close all;
load data.mat

fontsize = 16; 
set(0,'DefaultTextFontName','Times',...
    'DefaultTextFontSize',fontsize,...
    'DefaultAxesFontName','Times',...
    'DefaultAxesFontSize',fontsize,...
    'DefaultLineLineWidth',1,...
    'DefaultLineMarkerSize',7.75);

% clc; clear; close all; format long
% filename = 'PSO.xlsx';
% existData = xlsread(filename,'Sheet2');


%% PSOSA_new R/C/J 1:5

numUnique1 = uniqueSol(SA);
numUnique2 = uniqueSol(PSOSA_old);
numUnique3 = uniqueSol(SAavg);

% %% Rhwanda
% subplot(1,3,1)
% % PSOSA_old R/C/J 1:5, 6:9, 11:end
% ans1 = PSOSA_old(8:end,1:5);
% [mn,upp,low] = statistics(ans1);
% plot(mn,'g');
% hold on
% % SA R/C/J 1:5, 6:10, 11:end
% ans2 = SA(8:end,1:5);
% [mn,upp,low] = statistics(ans2);
% plot(mn,'r');
% % PSO R/C/J 1:5, 6:10, 11:end
% ans3 =SAavg(8:end,1:5);
% [mn,upp,low] = statistics(ans3);
% plot(mn,'b');
% xlim([0,500])
% ylabel('Distance')
% xlabel('Iteration')
% grid on
% 
% %% Canada
% subplot(1,3,2)
% % PSOSA_old R/C/J 1:5, 6:9, 11:end
% ans1 = PSOSA_old(8:end,6:9);
% [mn,upp,low] = statistics(ans1);
% plot(mn,'g');
% hold on
% % SA R/C/J 1:5, 6:10, 11:end
% ans2 = SA(8:end,6:10);
% [mn,upp,low] = statistics(ans2);
% plot(mn,'r');
% % PSO R/C/J 1:5, 6:10, 11:end
% ans3 = SAavg(8:end,6:10);
% [mn,upp,low] = statistics(ans3);
% plot(mn,'b');
% xlim([0,500])
% xlabel('Iteration')
% grid on
% 
% %% Japan
% subplot(1,3,3)
% % PSOSA_old R/C/J 1:5, 6:9, 11:end
% ans1 = PSOSA_old(8:end,11:end);
% [mn,upp,low] = statistics(ans1);
% plot(mn,'g');
% hold on
% % SA R/C/J 1:5, 6:10, 11:end
% ans2 = SA(8:end,11:end);
% [mn,upp,low] = statistics(ans2);
% plot(mn,'r');
% % PSO R/C/J 1:5, 6:10, 11:end
% ans3 = SAavg(8:end,11:end);
% [mn,upp,low] = statistics(ans3);
% plot(mn,'b');
% xlim([0,500])
% xlabel('Iteration')
% 
% h = legend('PSO/SA','SA','PSO','location','best')
% set(h,'FontSize',10);
% grid on
% print('-depsc2','-r600','distplot.eps')


