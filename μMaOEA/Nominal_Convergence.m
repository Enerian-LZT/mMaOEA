function Offspring = Nominal_Convergence(Problem, Parents)
% nominal_convergence --- 2
% crossover_rate --- 0.8
% mutation_rate --- 1

%% Nominal Convergence

    nominal_convergence = 2;
    crossover_rate = 0.8;
    mutation_rate = 1;

    for i = 1:nominal_convergence      
        Offspring = OperatorGA(Problem, Parents, {crossover_rate, 20, mutation_rate, 20});
        Parents = Offspring;
    end

    % Elitism
    Offspring = Parents;
    [FrontNo,~] = NDSort(Offspring.objs, 2);
    nonDominated = Offspring(FrontNo == 1);
    Offspring = nonDominated(      randperm(length(nonDominated), 1)       );
end