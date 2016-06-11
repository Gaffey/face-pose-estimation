clear;
close all;
clc;

obj = videoinput('winvideo');
set(obj, 'FramesPerTrigger', 1);
set(obj, 'TriggerRepeat', Inf);
%����һ����ؽ���
hf = figure('Position',[0,0,1280/0.9/1.5,720/0.7/1.5],'Units', 'Normalized', 'Menubar', 'None','NumberTitle', 'off', 'Name', '�����Ƕ�ϵͳ');
ha = axes('Parent', hf, 'Units', 'Normalized', 'Position', [0.05 0.2 0.9 0.7]);
axis off;
objRes = get(obj, 'VideoResolution');
nBands = get(obj, 'NumberOfBands');
hImage = image(zeros(objRes(2), objRes(1), nBands));
preview(obj, hImage);

txt = uicontrol('Parent', hf, 'Units', 'Normalized', 'Style', 'text', 'Visible', 'off', 'ForegroundColor', [1.0 0 0], 'Position', [0.1 0.05 0.1 0.1], 'FontSize', 20);
hb1 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.25 0.05 0.2 0.1], 'String', '�ⶨ�Ƕ�', 'Callback', 'Detect(obj, txt)');
hb2 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.55 0.05 0.2 0.1], 'String', '����', 'Callback', 'preview(obj);set(txt,''Visible'',''off'');');