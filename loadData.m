function  data = loadData(file)

A = dlmread(file);

nPoints = size(A,1);
a = meshgrid(1:nPoints);
xy = A(:,2:end);

data.dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),...
    nPoints,nPoints);
data.dataSet = A;

end

