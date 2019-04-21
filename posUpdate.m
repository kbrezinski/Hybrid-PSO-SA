function [newPos] = posUpdate(pos,vel,inert)

[dims, i] = size(vel);

for update = 1:dims 
    if rand() < inert
        pos([vel(update,2) vel(update,1)]) = pos([vel(update,1) vel(update,2)]);
    end
end

newPos = pos;

end

