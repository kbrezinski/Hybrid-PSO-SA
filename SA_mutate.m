function newMember = SA_mutate(swarmMember,mutCoeff)

% Randomizes each mutation to a Gaussian distribution
newMember = mutCoeff.*(randn(1,length(swarmMember)))+swarmMember;

end