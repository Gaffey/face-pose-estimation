function degrees = estimate(model, data)
    K_new_star = GPR.SEKernel(model.sigma_f, model.l, data, model.data);
    degrees = K_new_star * ((model.K_new + model.sigma_n^2 * eye(size(model.data,1))) \ model.degrees);
