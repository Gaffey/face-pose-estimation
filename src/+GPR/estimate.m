function degrees = estimate(model, data)
	if size(data, 2) > 5
        [coef, ~] = princomp(data);
        data = data * coef(:,1:3);
    end
    K_new_star = GPR.SEKernel(model.sigma_f, model.l, data, model.data);
    degrees = K_new_star * ((model.K_new + model.sigma_n^2 * eye(size(model.data,1))) \ model.degrees);
