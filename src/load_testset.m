function [P, F] = load_testset(filenames, label_dir, unify)
    count = size(filenames, 1);

    P = zeros(count, 98);
    F = zeros(count, 5);

    for k = 1:count
        filename = filenames{k};
        [points, features] = load_data(filename, label_dir, unify);

        P(k, :) = points(:);
        F(k, :) = features;
    end
