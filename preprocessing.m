%% Preprocessing

A = dlmread('CanadianCityList.txt');

nPoints = size(A,1);
a = meshgrid(1:nPoints);
xy = A(:,2:end);
dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),nPoints,nPoints);

popSize = 10;

% Verify Inputs
[N,dims] = size(A);
[nr,nc] = size(dmat);
if N ~= nr || N ~= nc
    error('Invalid XY or DMAT inputs!')
end
n = N - 2; % Separate Start and End Cities

% Initialize the Population
pop = zeros(popSize,n);
pop(1,:) = (1:n) + 1;
for k = 2:popSize
    pop(k,:) = randperm(n) + 1;
end

for p = 1:popSize
    d = dmat(1,pop(p,1)); % Add Start Distance
    for k = 2:n
        d = d + dmat(pop(p,k-1),pop(p,k));
    end
    d = d + dmat(pop(p,n),N); % Add End Distance
    totalDist(p) = d;
end