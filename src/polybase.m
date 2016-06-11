function [ set ] = polybase( X, p )
%return the poly base
%   [ set ] = polybase( X, p );
    set = [];
    for i = 1:p
        set = [set X.^i];
    end
    set = [set ones(size(X,1), 1)];
end

