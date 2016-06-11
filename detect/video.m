% fileName = 'IMG_3860.m4v';
fileName = 'IMG_3864.MOV';
% fileName = 'IMG_3868.MOV';
% fileName = 'IMG_3869.MOV';

load net
obj = VideoReader(fileName);
numFrames = obj.NumberOfFrames;% ֡������
for k = 1 : 20: numFrames% ��ȡ����
    frame = read(obj,k);
    frame = imresize(frame, 0.25);
    imshow(frame);%��ʾ֡
    imwrite(frame,'snapshot.jpg','jpg');% ����֡
    system('IntraFaceDetector.exe');
    points = load('snapshot.txt');
    hight = abs(mean(points([47:49], 2)) - mean(points([3 8], 2)));
    points = points / hight;
    points = bsxfun(@minus, points, mean(points));
    xs = points(:);
    sim(net, xs)
    pause;
end