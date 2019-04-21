function returns = SA(args, paramsPSO,paramsSA)

%% PSO args
dmat = args.dmat; % Distance Matrix
nVar = args.nVar; % Number of Decision Variables
varSize = args.varSize; % Size of Decision Variables

%% PSO params
MaxIt = paramsPSO.maxIterations; % Max Number of Iterations
nPop = paramsPSO.nPop; % Swarm Size
nMove = paramsPSO.nMove; % Number of Neighbors per Individual

%% Initialize Coefficients
inertia = paramsPSO.inertia * 0.8; % Chances of utilizing velocity vector
c1 = 0.8 - inertia; % Personal Acceleration Coefficient
c2 = 1 - (c1 + inertia); % Social Acceleration Coefficient
wDamp = paramsPSO.wDamp; % Dampening Coefficient
% randVel = paramsPSO.randVel; % Randomize the velocity vector

%% SA params
MaxSubIt = paramsSA.maxSubIterations; % Max Number of Subiterations
T = -1.0/log(paramsSA.tStart);% Initialize Start Temp.
tEnd = -1.0/log(paramsSA.tEnd);% Initialize Final Temp.
frac = (0.2/inertia)^(1.0/(MaxIt+(MaxIt/10))); % Ramping Coefficient
fracTemp = @(best,curr) 1.0 + ((best-curr)/best);

%% Initialization Empty Swarm

% Create Empty Structure for Individuals
emptySwarm.position = [];
emptySwarm.velocity = [];
emptySwarm.cost = [];
% emptySwarm.prevCost = [];
% emptySwarm.c1 = c1;
% emptySwarm.c2 = c2;
% emptySwarm.inertia = inertia;
emptySwarm.best.position = [];
emptySwarm.best.cost = [];

% Create Population Array
swarm = repmat(emptySwarm,nPop,1);

% Initialize Other Parameters
globalBest.cost = inf;
globalBest.position = [];

[N,dims] = size(dmat);
n = N - 2; % Separate Start and End Cities
steps = round(MaxIt/10); % Step Size

%% Initialize Population
for i = 1:nPop
    
    % Initialize Position and Cost
    swarm(i).position = randperm(n) + 1;
    swarm(i).cost = distanceCalc(swarm(i).position,dmat,N);
    swarm(i).velocity = randi([1,n],n,2);
    swarm(i).best.position = swarm(i).cost;
    swarm(i).best.cost = swarm(i).cost;
    
    % Update Global Best
    if swarm(i).best.cost < globalBest.cost
        globalBest = swarm(i).best;
    end
    
end

%% Array to Hold Best Cost Values
bestCosts = zeros(MaxIt, 1); % Best cost of each iteration
bestAvgCosts = zeros(MaxIt, 1); % Avg cost of each iteration
averageTemp = zeros(MaxIt, 1); % Temp of each iteration
deltaEavg = 0.0; numAccept = 1; avgTemp = 0;

%% SA Main Loop

for it = 1:MaxIt
    
    for subit = 1:MaxSubIt
        
        newpop=repmat(emptySwarm,nPop,nMove);
        % Create and Evaluate New Solutions
        for i=1:nPop
            for j=1:nMove
                
                % Create Neighbor
                newpop(i,j).position = posUpdate(...
                    swarm(i).position,swarm(i).velocity,inertia);
                
                % Evaluate Neighbor Cost
                newpop(i,j).cost = distanceCalc(...
                    newpop(i,j).position,dmat,N);
                
            end
        end
        
        % Sort Neighbors
        [~, SortOrder] = sort([newpop.cost]);
        newpop = newpop(SortOrder);
        avgCost = 0;
        
        %% Evaluate SA of population and members
        for i = 1:nPop
            
            %% SA Equilibrium Loop
            deltaE = abs(newpop(i).cost - swarm(i).cost);
            
            if newpop(i).cost > swarm(i).cost
                
                % Sets DeltaE_avg for first iteration
                if (it == 1 && subit == 1)
                    deltaEavg = deltaE;
                end
                
                P = exp(-deltaE / (deltaEavg * T));
                
                if rand < P
                    SAcond = true;
                else
                    SAcond = false;
                end
                
            else
                SAcond = true;
            end
            
            if SAcond == true
                newpop(i).best = swarm(i).best;
                swarm(i) = newpop(i);
                
                if swarm(i).best.cost > newpop(i).cost
                    swarm(i).best.cost = newpop(i).cost;
                    swarm(i).best.position = newpop(i).position;
                end
                
                swarm(i).best.cost = swarm(i).cost;
                swarm(i).best.position = swarm(i).position;
                numAccept = numAccept + 1;
                deltaEavg = (deltaEavg * (numAccept-1)...
                    + deltaE) / numAccept;
            end
            
            %% Update Best Particle Solution
            %             if swarm(i).best.cost > swarm(i).cost
            %                 swarm(i).best.cost = swarm(i).cost;
            %                 swarm(i).best.position = swarm(i).position;
            
            if swarm(i).cost < globalBest.cost
                globalBest = swarm(i).best;
            end
            %             end
            
            %% Check For Average Cost
            %             if subit == MaxSubIt
            avgCost = avgCost + swarm(i).cost;
            %             end
            
            %% Test for Velocity Dampening
            if rand() < wDamp; PSOcond = true; else; PSOcond = true; end
            
            % Apply Velocity Dampening
            if PSOcond == true || SAcond == true
                swarm(i).velocity = randi([1,n],n,2);
            else
                swarm(i).velocity = velUpdate(swarm(i).velocity,wDamp,n,PSOcond);
            end
            
        end
        
        % Update Temperature
        avgTemp = avgTemp + T;
        frac2 = fracTemp(globalBest.cost,avgCost/nPop); 
        T = frac2 * T;
        
    end
    
    %% Cost based on best positions of personal/social
%     swarm(i).position = posUpdateSoc(...
%         c1,swarm(i).position,swarm(i).best.position);
%     swarm(i).position = posUpdateSoc(...
%         c2,swarm(i).position,globalBest.position);
    
    %% Acceleration/Inertial Coefficient Adjustments
    inertiaNew = inertia * frac;
    delta = inertia - inertiaNew;
    c1 = c1 + (0.2 * delta);
    c2 = c2 + (0.8 * delta);
    
    %% Store Progress
    bestAvgCosts(it) = avgCost/nPop;
    bestCosts(it) = globalBest.cost;
    averageTemp(it) = avgTemp/MaxSubIt;
    
    %% Display Step Progress
    if mod(it,steps) == 0
        fprintf('Iteration %2d: Best Cost: %2d\n',it, bestCosts(it))
    end
    
end

%% Store Progress
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

subplot(1,3,3)
semilogx(averageTemp,'linewidth',2,'Color','g');
xlabel('Iteration'); ylabel('Avg Temperature');

end