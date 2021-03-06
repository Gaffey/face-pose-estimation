function Main(command, varargin)
    switch command
        case 'train'
            cmd_train(varargin{:});
        case 'test'
            cmd_test(varargin{:});
        case 'cam'
            cmd_cam(varargin{:});
        case 'video'
            cmd_video(varargin{:});
        otherwise
            error(['Unknown command: ' command]);
    end
end

function cmd_train(img_list, label_dir, method, model_file, unify)
    if ~exist('img_list', 'var')
        img_list = 'ImgList.txt';
    end
    if ~exist('label_dir', 'var')
        label_dir = 'label';
    end
    if ~exist('method', 'var')
        method = 'ANN';
    end
    if ~exist('model_file', 'var')
        model_file = method;
    end
    if ~exist('unify', 'var')
        unify = 'false';
    end

    filenames = importdata(img_list);
    [points, features, degrees] = load_trainset(filenames, label_dir, unify);

    switch method
        case 'GPR'
            model = GPR.train(features, degrees);
        case 'poly'
            model = poly.train(points, degrees);
        case 'LS'
            model = LS.train(points, degrees);
        case 'ANN'
            model = ANN.train(points, degrees);
        otherwise
            error(['Unknown method: ' method]);
    end

    save(model_file, 'model');
end

function cmd_test(img_list, label_dir, method, model_file, unify)
    if ~exist('img_list', 'var')
        img_list = 'ImgList.txt';
    end
    if ~exist('label_dir', 'var')
        label_dir = 'label';
    end
    if ~exist('method', 'var')
        method = 'ANN';
    end
    if ~exist('model_file', 'var')
        model_file = method;
    end
    if ~exist('unify', 'var')
        unify = 'false';
    end

    filenames = importdata(img_list);
    [points, features] = load_testset(filenames, label_dir, unify);
    load(model_file, 'model')

    switch method
        case 'GPR'
            degrees = GPR.estimate(model, features);
        case 'poly'
            degrees = poly.estimate(model, points);
        case 'LS'
            degrees = LS.estimate(model, points);
        case 'ANN'
            degrees = ANN.estimate(model, points);
        otherwise
            error(['Unknown method: ' method]);
    end

    degrees(degrees < -67) = -67;
    degrees(degrees > 67) = 67;

    fout = fopen('FacePosition.txt', 'w');
    for k = 1:size(filenames, 1)
        fprintf(fout, '%s ', filenames{k});

        degree = degrees(k);
        if isnan(degree)
            fprintf(fout, 'no_point\n');
        else
            fprintf(fout, '%.2f\n', degree);
        end
    end
    fclose(fout);

    % guesses = zeros(size(degrees));
    % guesses(degrees < -56) = -67;
    % guesses(degrees >= -56 & degrees < -37.5) = -45;
    % guesses(degrees >= -37.5 & degrees < -26) = -30;
    % guesses(degrees >= -26 & degrees < -18.5) = -22;
    % guesses(degrees >= -18.5 & degrees < -7.5) = -15;
    % guesses(degrees >= 7.5 & degrees < 18.5) = 15;
    % guesses(degrees >= 18.5 & degrees < 26) = 22;
    % guesses(degrees >= 26 & degrees < 37.5) = 30;
    % guesses(degrees >= 37.5 & degrees < 56) = 45;
    % guesses(degrees >= 56) = 67;
    % guesses = repmat([0; 15; 30; 45; -15; -30; -45], [104, 1]);

    % [degrees guesses]

    % err = nanmean((degrees - guesses).^2);
    % disp(['Estimated MSE = ' num2str(err)]);
end

function cmd_cam()
    cd detect
    camera
end

function cmd_video(filename)
    if ~exist('filename', 'var')
        filename = 'detect/speak.m4v';
    end

    degrees = [];
    load('detect/ANN', 'model');
    obj = VideoReader(filename);

    numFrames = obj.NumberOfFrames;
    selected_frames = 1:5:numFrames;

    for k = selected_frames
        frame = read(obj, k);
        frame = imresize(frame, 0.25);
        imshow(frame);
        imwrite(frame, 'detect/snapshot.jpg', 'jpg');
        system('cd detect & IntraFaceDetector.exe');

        points = load_testset({'detect\snapshot.jpg'}, 'detect', 'true');
        degree = ANN.estimate(model, points);
        degrees = [degrees degree];
        title(sprintf('Angle = %.1f degree', degree));
        drawnow
    end

    plot(selected_frames, degrees);
    xlabel frame
    ylabel degree
end
