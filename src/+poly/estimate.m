function degrees = estimate(model, data)
    TestSet_new =  poly.polybase(data, model.p);
    E_w = (model.TrainSet_new' * model.TrainSet_new + model.sigma_n * model.sigma_p^(-1)) \ model.TrainSet_new' * model.degrees;
    degrees = TestSet_new * E_w;
