clear;
close all;
clc;

obj = videoinput('winvideo');
set(obj, 'FramesPerTrigger', 1);
set(obj, 'TriggerRepeat', Inf);
%定义一个监控界面
hf = figure('Position',[0,0,1280/0.9/1.5,720/0.7/1.5],'Units', 'Normalized', 'Menubar', 'None','NumberTitle', 'off', 'Name', '测量角度系统');
ha = axes('Parent', hf, 'Units', 'Normalized', 'Position', [0.05 0.2 0.9 0.7]);
axis off;
objRes = get(obj, 'VideoResolution');
nBands = get(obj, 'NumberOfBands');
hImage = image(zeros(objRes(2), objRes(1), nBands));
preview(obj, hImage);

txt = uicontrol('Parent', hf, 'Units', 'Normalized', 'Style', 'text', 'Visible', 'off', 'ForegroundColor', [1.0 0 0], 'Position', [0.1 0.05 0.1 0.1], 'FontSize', 20);
hb1 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.25 0.05 0.2 0.1], 'String', '测定角度', 'Callback', 'Detect(obj, txt)');
hb2 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.55 0.05 0.2 0.1], 'String', '继续', 'Callback', 'preview(obj);set(txt,''Visible'',''off'');');