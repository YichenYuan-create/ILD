
close all; clear; clc;


paths = {
    '/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s13/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s14/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s15/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s18/session1/mrVistaSession_s18_ILD_Session1/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s19/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s20/mrVistaSession/Gray/MovingBinaural'
    '/media/harveylab/500GB/Yichen/Data/s21/mrVistaSession_s21_session1/Gray/MovingBinaural'
};


cd('/media/harveylab/500GB/Yichen/Data/s01/mrVistaSession');
mrVista 3


% 假设你的 mesh 变量在 msh 中
msh = viewGet(VOLUME{1}, 'curmesh');

% 提取坐标 (Vertices) 和 面 (Faces)
v = msh.vertices'; 
f = msh.triangles' + 1; % MATLAB 索引从 1 开始，需加 1

% 提取颜色 (Colors)
% 取前三行 (RGB)，并转置为 N x 3，除以 255 归一化
c = double(msh.colors(1:3, :))' / 255;

figure('Color', 'w'); % 创建白色背景窗口
p = patch('Vertices', v, 'Faces', f, ...
    'FaceVertexCData', c, ...
    'FaceColor', 'interp', ...
    'EdgeColor', 'none');

% 优化视觉效果
axis equal; 
axis off; 
view(-90, 0); % 这里可能需要根据你的模型调整视角，比如 (90,0) 或 (0,90)
camlight('headlight'); 
material dull; 
lighting gouraud;