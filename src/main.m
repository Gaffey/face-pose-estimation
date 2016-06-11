function Main(command, varargin)
    switch command
        case 'train'
            cmd_train(varargin);
        case 'test'
            cmd_test(varargin);
        case 'cam'
            cmd_cam(varargin);
        case 'video'
            cmd_video(varargin);
        otherwise
            error(['Unknown command: ' command]);
    end
end

function cmd_train(img_list, label_dir, method)
    if ~exist('img_list', 'var')
        img_list = 'ImgTrainList.txt';
    end
    if ~exist('label_dir', 'var')
        label_dir = 'label';
    end
    if ~exist('method', 'var')
        method = 'ANN';
    end

    [points, features, degrees] = load_trainset(img_list, label_dir);

    switch method
        case 'GPR'
            model = GPR.train(points, degrees);
        case 'poly'
            model = poly.train(points, degrees);
        case 'LS'
            model = LS.train(points, degrees);
        case 'ANN'
            model = ANN.train(points, degrees);
        otherwise
            error(['Unknown method: ' method]);
    end
end

function cmd_test(img_list, label_dir, method, model_file)
    if ~exist('img_list', 'var')
        img_list = 'ImgTrainList.txt';
    end
    if ~exist('label_dir', 'var')
        label_dir = 'label';
    end
    if ~exist('method', 'var')
        method = 'ANN';
    end
    if ~exist('model', 'var')
        model_file = method;
    end

    [points, features] = load_testset(img_list, label_dir);
    load(model_file, 'model')

    switch method
        case 'GPR'
            degrees = GPR.estimate(model, points);
        case 'poly'
            degrees = poly.estimate(model, points);
        case 'LS'
            degrees = LS.estimate(model, points);
        case 'ANN'
            degrees = ANN.estimate(model, points);
        otherwise
            error(['Unknown method: ' method]);
    end
end

function cmd_cam()
end

function cmd_video()
    angles = [];
    load net
    obj = VideoReader(fileName);
    numFrames = obj.NumberOfFrames;
    for k = 1 : 5: numFrames
        frame = read(obj,k);
        frame = imresize(frame, 0.25);
        imshow(frame);
        imwrite(frame,'snapshot.jpg','jpg');
        system('IntraFaceDetector.exe');
        points = load('snapshot.txt');
        hight = abs(mean(points([47:49], 2)) - mean(points([3 8], 2)));
        points = points / hight;
        points = bsxfun(@minus, points, mean(points));
        xs = points(:);
        angle = sim(net, xs);
        angles(k) = angle;
        title(['Angle = ' num2str(angle) ' degree']);
        drawnow
    end
end
