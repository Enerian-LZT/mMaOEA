function [W1,N] = UniformlyRandomlyPoint(N,M)
% Generate a set of uniform randomly distributed points on the unit hyperplane
	
    W1 = eye(M,M);
	W1 = [W1;ones(1,M)/M];
    
	W2 = rand(5000,M);
    % Normalization
	W2 = W2./repmat(sum(W2,2),1,size(W2,2));
	
	while size(W1,1) < N
		index = find_index_with_largest_distance (W1,W2);
		W1(size(W1,1)+1,:)=W2(index,:);
		W2(index,:)=[];
	end	
    W1 = max(W1,1e-6);
    N  = size(W1,1);
end

function index = find_index_with_largest_distance (W1,W2)
    Distance = pdist2(W2,W1);
    Temp     = sort(Distance,2);
    [~,Rank] = sortrows(Temp);
    index=Rank(length(Rank));
end