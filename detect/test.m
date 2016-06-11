close all
clear all
clc;
files=dir('D:\zhouyn\FER\ck+\8\bmp\bmp\*.bmp');

LeftEye=20:25;
RightEye=26:31;
% LE=[315,227];
% RE=[375,227];
Order = [1,5,6,10,14,15,19,32,38];

EyeD=60;
Mouthfeatures=zeros(length(files),26);
Eyefeature=zeros(length(files),24);
for i=1:1;
    
    img=imread(['D:\zhouyn\FER\ck+\8\bmp\bmp\',files(i).name]);
    fid=fopen(['D:\zhouyn\FER\ck+\8\bmp\txt\',files(i).name(1:end-4),'.txt'],'rt');
    feature=fscanf(fid,'%f %f',[2 49]);
    feature=feature';
    fclose(fid);
    
    figure;
    imshow(img);
    hold on;
    plot(feature(:,1),feature(:,2),'.b');
    
    figure;
    imshow(img);
    hold on;
    plot(feature(Order,1),feature(Order,2),'.r');
    
end

