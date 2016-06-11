function Main(runmode = 'test', method = 'ANN', fileName = '')
    if runmode == 'train'
        f = fopen('ImgTrainList.txt');
        detecteddir = '../points';
        line = fgets(f);
        output = [];
        while line ~= -1
            sep = find(line==filesep);
            if sep
                name = [line(sep(end):find(line=='.')),'txt'];
            else
                name = [line(1:find(line=='.')),'txt'];
            end
            tmp = load(fullfile(detecteddir,name));
            features = [...
                abs(tmp(1,1)-tmp(5,1))/abs(tmp(6,1)-tmp(10,1))...
                abs(tmp(20,1)-tmp(23,1))/abs(tmp(26,1)-tmp(29,1))...
                atan((tmp(11,2)-tmp(14,2))/(tmp(11,1)-tmp(14,1)))...
                abs(tmp(17,1)-tmp(15,1))/abs(tmp(19,1)-tmp(17,1))];
            midx = (tmp(35,1)+tmp(45,1)+tmp(48,1)+tmp(41,1))/4;
            features = [features,abs(midx-tmp(32,1))/abs(midx-tmp(38,1))];
            pos = find(line=='_');
            features = [features,str2double(line(pos(3)+3:pos(4)-1))];
            output = [output;features];
            line = fgets(f);
        end
        output(output(:,3) < 0) = output(output(:,3) < 0) + pi;
        data = output(:,1:6);
        if method == 'GPR'
            sigma_f = 1250;
            sigma_n = 0.28;
            l = 0.5;
            K_new = SEKernel(sigma_f, l, data(:,1:5), data(:,1:5));
            save GPRdata.mat K_new data sigma_f l sigma_n
        elseif method == 'poly'
            p = 2;
            A = [data(:,1:5) data(:,1:5).^2 ones(size(data(:,1:5),1),1)];
            weight = (A'*A)\(A'*y);
            regression = [data(:,1:5) data(:,1:5).^2 ones(size(data(:,1:5), 1), 1)] * weight;
            sigma_n = sum((regression - data(:,6)).^2)/size(data(:,1:5), 1);
            sigma_p = diag(2*ones(1,size(data(:,1:5),2)*2+1), 0).^2;
            TrainSet_new = polybase(data(:,1:5),p);
            save polydata.mat TrainSet_new data sigma_p p sigma_n
        elseif method == 'LS'
            A_new = [data(:,1:5) ones(size(data(:,1:5),1),1)];
            weight_new = (A_new'*A_new)\(A_new'*data(:,6));
            save LSdata.mat weight_new
        elseif method == 'ANN'
            %to do
        else
            disp('incorrect method');
        end            
    elseif runmode == 'test'
        f = fopen('ImgTestList.txt');
        detecteddir = '../points';
        line = fgets(f);
        output = [];
        while line ~= -1
            sep = find(line==filesep);
            if sep
                name = [line(sep(end):find(line=='.')),'txt'];
            else
                name = [line(1:find(line=='.')),'txt'];
            end
            tmp = load(fullfile(detecteddir,name));
            features = [...
                abs(tmp(1,1)-tmp(5,1))/abs(tmp(6,1)-tmp(10,1))...
                abs(tmp(20,1)-tmp(23,1))/abs(tmp(26,1)-tmp(29,1))...
                atan((tmp(11,2)-tmp(14,2))/(tmp(11,1)-tmp(14,1)))...
                abs(tmp(17,1)-tmp(15,1))/abs(tmp(19,1)-tmp(17,1))];
            midx = (tmp(35,1)+tmp(45,1)+tmp(48,1)+tmp(41,1))/4;
            features = [features,abs(midx-tmp(32,1))/abs(midx-tmp(38,1))];
            output = [output;features];
            line = fgets(f);
        end
        output(output(:,3) < 0) = output(output(:,3) < 0) + pi;
        newdata = output(:,1:5);
        if method == 'GPR'
            load GPRdata.mat
            K_new_star = SEKernel(sigma_f, l, newdata(:, 1:5), data(:, 1:5));
            predict = K_new_star * ((K_new + sigma_n^2 * eye(size(X,1))) \ data(:, 6));
        elseif method == 'poly'
            load polydata.mat
            TestSet_new =  polybase(newdata(:,1:5),p);
            E_w = (TrainSet_new' * TrainSet_new + sigma_n * sigma_p^(-1)) \ TrainSet_new' * data(:,6);
            predict = TestSet_new * E_w;
        elseif method == 'LS'
            load LSdata.mat
            predict = [newdata ones(size(newdata,1), 1)] * weight_new;
        elseif method == 'ANN'
            %to do
        else
            %shoule use assert?
            disp('incorrect method');
        end
        %to add: write to ouput file
    elseif runmode == 'cam'
        %to do
    elseif runmode == 'video'
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
end