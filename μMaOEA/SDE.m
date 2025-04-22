function Archive = SDE(Problem, Archive)
%% SDE Environmental Selection

    Del  = Truncation(Archive.objs, length(Archive)-Problem.N);
    Archive = Archive(~Del);
end

function Del = Truncation(PopObj,K)
%% Select part of the solutions by truncation
    N = size(PopObj,1);
    
    % Calculate the shifted distance between each two solutions
    Distance = inf(N);
    for i = 1 : N
        SPopObj = max(PopObj,repmat(PopObj(i,:),N,1));
        for j = [1:i-1,i+1:N]
            Distance(i,j) = norm(PopObj(i,:)-SPopObj(j,:));
        end
    end
    
    % Truncation
    Del = false(1,N);
    while sum(Del) < K
        Remain   = find(~Del);
        Temp     = sort(Distance(Remain,Remain),2);
        [~,Rank] = sortrows(Temp);
        Del(Remain(Rank(1))) = true;
    end
end