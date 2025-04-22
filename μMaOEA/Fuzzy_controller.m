function Archive = Fuzzy_controller(Problem, Archive, Population, ratio)
    global NOW;
    N = length(Population);

    %% Chaotic Maps
    ch(1)=rand;
    for i = 1:N-1
        ch(i+1) = 3.7 * ch(i) * (1 - ch(i));
    end

    Autoregulators = sigmf(ratio,[25 0.3]);

    if mean(ch) > Autoregulators
    %% First stage：local search
        Archive = LocalSearch(Problem, Archive, Population);
    else
    %% Second stage：SDE
        Archive = SDE(Problem, [Archive, Population(NOW)]);
    end
end