function [mn,upp,low] = statistics(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(data)
    
x = data(i,:);  

SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1); % T-Score
CI = mean(x) + ts*SEM;  
low(i) = CI(1); 
upp(i) = CI(2);   
mn(i) = mean(x);

end
end
