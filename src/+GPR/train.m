function model = train(data, degrees)
    sigma_f = 1250;
    sigma_n = 0.28;
    l = 0.5;
    if size(data, 2) > 5
        sigma_f = 15;
        sigma_n = 0.25;
        l = 12.5;
        [coef, ~] = princomp(data);
        data = data * coef(:,1:3);
    end
    K_new = GPR.SEKernel(sigma_f, l, data, data);

    model = struct('sigma_f', sigma_f, ...
                   'sigma_n', sigma_n, ...
                   'l', l, ...
                   'K_new', K_new, ...
                   'data', data, ...
                   'degrees', degrees);
