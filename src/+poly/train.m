function model = train(data, degrees)
    p = 5;
    A = poly.polybase(data, p);
    weight = (A'*A)\(A'*degrees);
    regression = A * weight;
    sigma_n = sum((regression - degrees).^2)/size(data, 1);
    sigma_p = diag(2*ones(1, size(data, 2)*p+1), 0).^2;
    TrainSet_new = poly.polybase(data, p);

    model = struct('p', p, ...
                   'sigma_n', sigma_n, ...
                   'sigma_p', sigma_p, ...
                   'TrainSet_new', TrainSet_new, ...
                   'degrees', degrees);
