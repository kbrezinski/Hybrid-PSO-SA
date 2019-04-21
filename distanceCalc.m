function totalDist = distanceCalc(position,dmat,N)

    n = N - 2; % Separate Start and End Cities

    d = dmat(1,position(1)); % Add Start Distance
    
    for k = 2:n
        d = d + dmat(position(k-1), position(k));
    end
    
    d = d + dmat(position(n),N); % Add End Distance
    totalDist = d;

end