function [ K ] = SEKernel( sigma_f, l, X, X_star )
%return squared-exponential covariance function K(X, X*)
%   [ K ] = SEKernel( sigma_f, l, X, X_star );
    dim = size(X, 2);
    K = zeros(size(X, 1), size(X_star, 1));
    for i = 1:dim
        K = K + (X(:,i) * ones(1,size(X_star,1)) - (X_star(:,i) * ones(1,size(X,1)))');
    end
    K = sigma_f^2 * exp(-K.^2/(2*l^2));
end

