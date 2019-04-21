clc; clear; close all; format long

%% Load Data and Preprocessing

file = 'JapanCityList.txt';
dataSpace = loadData(file);
% scatter(-dataSpace.dataSet(:,3),dataSpace.dataSet(:,2),'rx');
% title('Canadian City Coordinates')
% hold on
%% Problem Definition

[m, n] = size(dataSpace.dataSet);
args.dataSet = dataSpace.dataSet; % City list and distances
args.dmat = dataSpace.dmat; % Distance matrix
args.nVar = 2; % Number of Decision Variables
args.varSize = [1, args.nVar]; % Size of Decision Variables

%% Set arguments for tracking progress
trackExcel = true; type = 'PSO/SA before C1 changes'; 

%% Parameters of PSO
%inertias = [0.95,0.90,0.85,0.8,0.75];

for totalIt = 1:5

paramsPSO.maxIterations = 500; % Max Number of Iterations
paramsPSO.nPop = 250; % Swarm Size
paramsPSO.nMove = 3; % Number of Neighbors per Individual
paramsPSO.inertia = 0.8; % Chances of utilizing velocity vector
% paramsPSO.c1 = 1-paramsPSO.inertia; % Chances of adopting personal best/inertia
paramsPSO.wDamp = 0.95; % Chances of dampening velocity vector
paramsPSO.randVel = false; % Randomize the velocity vector; set to false for more exploration

%% Parameter of SA
paramsSA.maxSubIterations = 50; % Max Number of Subiterations
% paramsSA.tempFunction = 2; %1 for adaptive, 2 for sigmoid
paramsSA.tEnd = 0.05;  % Final temperature
paramsSA.tStart = 0.95;  % Start temperature

%% Function calls

returns = PSO(args,paramsPSO,paramsSA);
globalBest = returns.globalBest;
bestCosts = returns.bestCosts;
avgCosts = returns.avgCosts;

if trackExcel == true
    %% Export Into Excel Sheet
   filename = 'PSO.xlsx';
    [existData1] = xlsread(filename,'Sheet1');
    [existData2] = xlsread(filename,'Sheet2');
    newData1 = [existData1,[paramsPSO.maxIterations;paramsSA.maxSubIterations...
        ;paramsPSO.nPop;paramsPSO.nMove;globalBest.cost;paramsPSO.wDamp;paramsPSO.nPop;bestCosts]];
    newData2 = [existData2,[paramsPSO.maxIterations;paramsSA.maxSubIterations...
        ;paramsPSO.nPop;paramsPSO.nMove;globalBest.cost;paramsPSO.wDamp;paramsPSO.nPop;avgCosts]];
    xlswrite(filename,newData1,'Sheet1');  % write new data into excel sheet.
    xlswrite(filename,newData2,'Sheet2');  % write new data into excel sheet.
end

end
% for i = 1:length(globalBest.position)-1
%    plot([-dataSpace.dataSet(globalBest.position(i),3) -dataSpace.dataSet(globalBest.position(i+1),3)],...
%        [dataSpace.dataSet(globalBest.position(i),2) dataSpace.dataSet(globalBest.position(i+1),2)],'k'); 
% end
