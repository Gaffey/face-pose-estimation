function degrees = estimate(model, data)
    TestSet_new =  polybase(data, model.p);
    E_w = (TrainSet_new' * TrainSet_new + model.sigma_n * model.sigma_p^(-1)) \ TrainSet_new' * model.degrees;
    degrees = TestSet_new * E_w;
