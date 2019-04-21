clc; clear; close all; format long

fontsize = 16; 
set(0,'DefaultTextFontName','Times',...
    'DefaultTextFontSize',fontsize,...
    'DefaultAxesFontName','Times',...
    'DefaultAxesFontSize',fontsize,...
    'DefaultLineLineWidth',1,...
    'DefaultLineMarkerSize',7.75);

% inertia = 0.95;
MaxIt = 100;

inertia = 0.8; % Chances of utilizing velocity vector
c1 = (1-inertia)*0.8; % Persoal Acceleration Coefficient
c2 = 1 - (c1+inertia); % Social Acceleration Coefficient
frac2 = (0.2/inertia)^(1.0/(MaxIt+(MaxIt/10))); % Ramping Coefficient

for i = 1:MaxIt
    
inertia(i+1) = inertia(i) * frac2;
delta = inertia(i)-inertia(i+1);
c1(i+1) = c1(i) + (0.2 * delta);
c2(i+1) = c2(i) + (0.2 * delta);

end

plot(inertia,'r'); hold on; plot(c1,'b'); plot(c2,'g');

ylabel('Probability')
xlabel('Iteration')
xlim([0,MaxIt])
set(gca,'xtick',[])
legend('Inertial Coefficient','Personal Coefficient',...
    'Swarm Coefficient','location','best')
grid on
print('-depsc2','-r600','plotfile3.eps')