function [P, F, degrees] = load_trainset(filenames, label_dir, unify)
    count = size(filenames, 1);

    P = zeros(count, 98);
    F = zeros(count, 5);
    degrees = zeros(count, 1);

    for k = 1:count
        filename = filenames{k};
        tokens = regexp(filename, 'PM([+-]\d{2})_EN', 'tokens');
        [points, features] = load_data(filename, label_dir, unify);

        P(k, :) = points(:);
        F(k, :) = features;
        degrees(k) = str2num(tokens{1}{1});
    end
