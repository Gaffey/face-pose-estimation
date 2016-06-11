function [P, F] = load_testset(img_list, label_dir)
    filenames = importdata(img_list);
    count = size(filenames, 1);

    P = zeros(count, 98);
    F = zeros(count, 5);

    for k = 1:count
        filename = filenames{k};
        [points, features] = load_data(filename, label_dir);

        P(k, :) = points(:);
        F(k, :) = features;
    end
