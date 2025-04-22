function ind = Gauss_mutation(ind, lower, upper)
%% Gaussian mutation

   x = ind;
   [len, dim]= size(x);
   sigma = (upper - lower) ./ 20;
   prob = 1 / dim;
   newparam = min(max(normrnd(x, repmat(sigma, len, 1)), repmat(lower, len, 1)), repmat(upper, len, 1));
   C = rand(len, dim) < prob;
   x(C) = newparam(C');
   ind = x;
end
    