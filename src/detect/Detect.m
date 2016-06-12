function Detect(obj, txt)
    load ANN
    frame = getsnapshot(obj);
    stoppreview(obj);
    frame = imresize(frame, 0.25);
    imwrite(frame,'snapshot.jpg','jpg');% ±£¥Ê÷°
    system('IntraFaceDetector.exe');
    points = load('snapshot.txt');
    hight = abs(mean(points([47:49], 2)) - mean(points([3 8], 2)));
    points = points / hight;
    points = bsxfun(@minus, points, mean(points));
    xs = points(:);
    angle = sim(model.net, xs);
    set(txt,'Visible','on');
    set(txt,'String',sprintf('%.3f',angle));
end
