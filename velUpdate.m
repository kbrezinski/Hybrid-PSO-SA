function vel = velUpdate(vel,wDamp,n,cond)

if cond == false
    if rand() > wDamp
        vel = randi([1,n],round(wDamp*length(vel)),2);
    end   
else
    vel = randi([1,n],n,2);
end

end