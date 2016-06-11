function data = load_testset(img_list, label_dir)
    data = [];
    for filename = importdata(img_list)'
        data = [data; load_data(filename, label_dir)];
    end
