function [numUnique] = uniqueSol(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numElem = size(data);

for i = 1:numElem(2)
    x = data(8:end,i);
    [U,idx,idy] = unique(x);
    numUnique(i) = length(U);
end

end

