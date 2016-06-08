POINTS_DIR = 'points';
% FACEFP_DIR = 'facefp';
files = dir([POINTS_DIR '/*.txt']);
len = length(files);

% xs = zeros(98 + 4, len);
xs = zeros(98, len);
ys = zeros(1, len);

for k = 1:len
    file = files(k);

    points = load([SUBDIR '/' file.name]);
    hight = abs(mean(points([47:49], 2)) - mean(points([3 8], 2)));
    points = points / hight;
    % facefp = load([FACEFP_DIR '/' file.name])';
    points = bsxfun(@minus, points, mean(points));

    % xs(:, k) = [points(:); facefp];
    xs(:, k) = points(:);

    tokens = regexp(file.name, 'PM([+-]\d{2})_EN', 'tokens');
    ys(k) = str2num(tokens{1}{1});
end
