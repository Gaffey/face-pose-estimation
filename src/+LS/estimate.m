function degrees = estimate(model, data)
    degrees = [data, ones(size(data,1), 1)] * model.weight_new;
