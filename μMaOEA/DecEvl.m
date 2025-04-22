function [Population] = DecEvl(Problem, Population)
%% Decomposition Evolution

% delta --- 0.9 --- The probability of choosing parents locally
% nr    --- 2 ---   Maximum number of solutions replaced by each offspring

    global B;
    global W;
    global NOW;

    % size of pop
    N = length(NOW);

    % Ideal point initialization 
    Z = min(Population.objs,[],1);

    %% Detect the neighbours of each solution
    T = N;
    % Theta   = 5*ones(N,1);

    %calculat neighboring angle for angle normalization
    cosineW = W*W';
    [scosineW, ~] = sort(cosineW, 2, 'descend');
    acosW = acos(scosineW(:, 2));
    refW = rad2deg(acosW);
    
    % extream point
    [FrontNo, ~] = NDSort(Population.objs, Problem.N);
    NonDominated    = (FrontNo == 1);
    FunctionValue = Population.objs;
    BFunctionValue  = FunctionValue(NonDominated, :);
    Population_Dec = Population.decs;
    BPopulation     = Population_Dec(NonDominated, :);
    [~, ZmaxInd] = max(BFunctionValue,[],1);
    ZmaxFV  = BFunctionValue(ZmaxInd, :);
    ZmaxPop = BPopulation(ZmaxInd, :);

    uFunctionValue = (FunctionValue - repmat(Z, [size(FunctionValue,1) 1]));
    uFunctionValue = uFunctionValue./repmat(sqrt(sum(uFunctionValue.^2,2)), [1 Problem.M]);
    cosine         = sum(uFunctionValue.*W,2);
    Theta          = 0.06*Problem.M*(refW + rad2deg(acos(cosine)));

    % For each solution
    Offsprings(1:N) = SOLUTION();
    delta = 0.9;
    chosenNeighborhood = rand(N,1) < delta;
    for i = 1 : N
        % Choose the parents
        if chosenNeighborhood(i) == 1
            P = B(NOW(i), randperm(size(B,2)));
        else
            P = randperm(Problem.N, T);
        end
        
        % Nominal_Convergence
        Offsprings(i) = Nominal_Convergence(Problem, Population(P(1:2)));

        % generate an offspring
        Offspring    = Offsprings(i).decs;
        OffspringFV  = Offsprings(i).objs;
        
        % Update the ideal point
        Z = min(Z, Offsprings(i).obj);
        
        % the translation
        uOffspringFV = (OffspringFV - repmat(Z, [size(OffspringFV,1) 1]));
        
        % the association
        uOffspringFV = uOffspringFV./repmat(sqrt(sum(uOffspringFV.^2,2)), [1 Problem.M]);
        cosineOFF    = uOffspringFV*W'; % calculate the cosine values between each solution and each vector
        [~, maxcidx] = max(cosineOFF, [], 2);
        R = maxcidx;
        % update the population
        if CalPBI(FunctionValue(R,:),R, Theta, Z, W) > CalPBI(OffspringFV,R, Theta, Z, W)
            Population(R) = Problem.Evaluation(Offspring);
        end
    end

    % update the extream point
    CombineFV      = [FunctionValue;ZmaxFV];%otherOffspringFV];
    CombinePop     = [Population_Dec;ZmaxPop];%otherOffspring];
    [FrontNo,~] = NDSort(Population.objs, Problem.N);
    NonDominated   = (FrontNo == 1);
    BFunctionValue = CombineFV(NonDominated,:);
    BPopulation    = CombinePop(NonDominated,:);
    [Zmax, ZmaxInd] = max(BFunctionValue,[],1);
    ZmaxFV  = BFunctionValue(ZmaxInd,:);
    ZmaxPop = BPopulation(ZmaxInd,:);

    if ~mod(ceil(Problem.FE/Problem.N),ceil(Problem.maxFE/Problem.N*0.1)) && ceil(Problem.FE/Problem.N) ~= ceil(Problem.maxFE/Problem.N)
        W = W.*repmat((Zmax - Z)*1.0, Problem.N,1);
       for i = 1:Problem.N
            W(i,:) = W(i,:)./norm(W(i,:));
        end
        B     = pdist2(W,W);
        [~,B] = sort(B,2);
        B     = B(:,1:T);
        cosineW = W*W';
        [scosineW, ~] = sort(cosineW, 2, 'descend');
        acosW = acos(scosineW(:,2));
        refW = rad2deg(acosW);
        ZmaxFV  = [];
        ZmaxPop = [];
    end

end