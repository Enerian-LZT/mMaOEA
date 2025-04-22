function [ScalarValue] = CalPBI(FunctionValue, sub, Theta, Z, W)
%% Calculate scalar value of PBI

    [N, ~] = size(FunctionValue);
    normW   = sqrt(sum(W(sub,:).^2,2));
    normP   = sqrt(sum((FunctionValue-repmat(Z,N,1)).^2,2));
    CosineP = sum((FunctionValue-repmat(Z,N,1)).*repmat(W(sub,:),N,1),2)./normW./normP;
    d1 = normP.*CosineP;
    d2 = normP.*sqrt(1-CosineP.^2);
    ScalarValue = d1 + Theta(sub)*d2;
end