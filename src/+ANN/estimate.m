function degrees = estimate(model, data)
    degrees = sim(model.net, data')';
