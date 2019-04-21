function returns = PSO(args, paramsPSO,paramsSA)

%% PSO args
dmat = args.dmat; % Distance Matrix
nVar = args.nVar; % Number of Decision Variables
varSize = args.varSize; % Size of Decision Variables

%% PSO params
maxIterations = paramsPSO.maxIterations; % Max Number of Iterations
nPop = paramsPSO.nPop; % Swarm Size

%% Initialize Coefficients
inertia = paramsPSO.inertia; % Chances of utilizing velocity vector
c1 = (1-inertia)*0.8; % Persoal Acceleration Coefficient
c2 = 1 - (c1+inertia); % Social Acceleration Coefficient
frac2 = (0.2/inertia)^(1.0/(maxIterations+(maxIterations/10))); % Ramping Coefficient
randVel = paramsPSO.randVel; % Randomize the velocity vector

%% Initialization Empty Swarm
emptySwarm.position = [];
emptySwarm.velocity = [];
emptySwarm.inertia = [];
emptySwarm.cost = [];
emptySwarm.prevCost = [];

emptySwarm.best.position = [];
emptySwarm.best.cost = [];

swarm = repmat(emptySwarm,nPop,1);

globalBest.cost = inf;
[N,dims] = size(dmat);
n = N - 2; % Separate Start and End Cities
steps = round(maxIterations/10);

%% Create Population Members

for i = 1:nPop
    
    %% Settings for permutation problem
    swarm(i).position = randperm(n) + 1;
    swarm(i).cost = distanceCalc(swarm(i).position,dmat,N);
    
    %% Tests whether or not to randomize the velocity vector
    if randVel == true
        swarm(i).velocity = randi([1,n],round(rand()*n),2);
    else
        swarm(i).velocity = randi([1,n],n,2);
    end
    
    swarm(i).best.position = swarm(i).position;
    swarm(i).best.cost = swarm(i).cost;
    
    if swarm(i).best.cost < globalBest.cost
        globalBest = swarm(i).best;
    end
    
end

bestCosts = zeros(maxIterations, 1); % Best cost of each iteration
bestAvgCosts = zeros(maxIterations, 1); % Avg cost of each iteration
averageTemp = zeros(maxIterations, 1); % Temp of each iteration

%% Main PSO Loop
for it = 1:maxIterations
    
    avgCost = 0;

    for i = 1:nPop
    
        swarm(i).position = posUpdate(swarm(i).position,swarm(i).velocity,inertia);
        swarm(i).prevCost = swarm(i).cost;
        
        %% Cost based on best positions of personal/social
        swarm(i).position = posUpdateSoc(...
            c1,swarm(i).position,swarm(i).best.position);
        swarm(i).position = posUpdateSoc(...
            c2,swarm(i).position,globalBest.position);
        
        % Test new distance calculation on new member
        swarm(i).cost = distanceCalc(swarm(i).position,dmat,N);
        
        % Velocity Update
%         swarm(i).velocity = velUpdate(swarm(i).velocity,wDamp,n,cond);
%         swarm(i).velocity = velUpdate(swarm(i).velocity,wDamp,n,cond);
        
        %% Check if new cost is better than best cost
        if swarm(i).cost < swarm(i).best.cost
            swarm(i).best.position = swarm(i).position;
            swarm(i).best.cost = swarm(i).cost;
            
            if swarm(i).best.cost < globalBest.cost
                globalBest = swarm(i).best;
            end
        end
        
        %% Needed?
        %         wDamp = WDamp*frac2;
        
        avgCost = avgCost + swarm(i).cost;
        
    end
    
    %% Acceleration/Inertial Coefficient Adjustments
    
    inertiaNew = inertia * frac2;
    delta = inertia - inertiaNew;
    c1 = c1 + (0.2 * delta);
    c2 = c2 + (0.2 * delta);
    
    
    bestAvgCosts(it) = avgCost/nPop;
    bestCosts(it) = globalBest.cost;
    
    if mod(it,steps) == 0
        fprintf('Iteration %2d: Best Cost: %2d\n',it, bestCosts(it))
    end
    
end

returns.globalBest = globalBest;
returns.bestCosts = bestCosts;
returns.avgCosts = bestAvgCosts;

%% Plotting

figure;
subplot(1,3,1)
semilogx(bestCosts,'linewidth',2,'Color','r');
xlabel('Iteration'); ylabel('Best Cost');

subplot(1,3,2)
semilogx(bestAvgCosts,'linewidth',2,'Color','b');
xlabel('Iteration'); ylabel('Avg Cost');

end