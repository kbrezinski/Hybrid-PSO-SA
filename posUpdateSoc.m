function position = posUpdateSoc(c,position,best)

test = (position == best);

for i = 1:length(position)
    
    if rand() > c && test(i) == 1
        position(i) = best(i);
    end
        
end

end

