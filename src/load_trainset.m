function [data, degrees] = load_trainset(img_list, label_dir)
    filenames = importdata(img_list);
    count = size(filenames, 1);
    data = zeros(count, 5);
    degrees = zeros(count, 1)

    for k = 1:count
        filename = filenames{k};
        data(k, :) = [data; load_data(filename, label_dir)];
        tokens = regexp(file.name, 'PM([+-]\d{2})_EN', 'tokens');
        degrees(k) = [degrees; str2num(tokens{1}{1})];
    end
