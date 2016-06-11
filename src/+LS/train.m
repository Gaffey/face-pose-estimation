function model = train(data, degrees)
    A_new = [data ones(size(data,1),1)];
    weight_new = (A_new'*A_new)\(A_new'*degrees);

    model = struct('weight_new', weight_new);
