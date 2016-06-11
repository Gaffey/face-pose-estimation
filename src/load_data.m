function [points, features] = load_data(filename, label_dir, unify)
    [filedir, name, ext] = fileparts(filename);

    points_file = fullfile(label_dir, [name '.txt']);
    if ~exist(points_file, 'file')
        % Fallback to the default place.
        points_file = fullfile(filedir, [name '.txt']);
    end
    points = load(points_file);

    midx = (points(35, 1) + points(45, 1) + points(48, 1) + points(41, 1)) / 4;
    features = [
        abs(points(1, 1) - points(5, 1)) / abs(points(6, 1) - points(10, 1))...
        abs(points(20, 1) - points(23, 1)) / abs(points(26, 1) - points(29, 1))...
        atan((points(11, 2) - points(14, 2)) / (points(11, 1) - points(14, 1)))...
        abs(points(17, 1) - points(15, 1)) / abs(points(19, 1) - points(17, 1))...
        abs(midx - points(32, 1)) / abs(midx - points(38, 1))...
    ];

    if unify
        hight = abs(mean(points([47:49], 2)) - mean(points([3 8], 2)));
        points = points / hight;
        points = bsxfun(@minus, points, mean(points));
    end

    features(features(:,3) < 0) = features(features(:,3) < 0) + pi;
