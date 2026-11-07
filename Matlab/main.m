clc, clear variables, close all

rozmer = [50,370,50,500,50];    % [offset, rameno, offset od ramena, karbon tyc ,offset k konec bodu]
pos = [-100,0,-400] ;              % [x,y,z]

% natazeni = [260,260,260];
% [pos(1),pos(2),pos(3)] = PrimaKinematika(rozmer,natazeni);
% [U,V,W] = InverzniKinematika(rozmer,pos);

% Vykresleni robotu a spojnice koncovych bodu
figure
hold on
robot1 = vykresleni_deltabot(rozmer,pos,[0,0,0],180);
robot2 = vykresleni_deltabot(rozmer,pos,[400,0,0],0,'r');
koncove_body = [robot1;robot2];
plot3(koncove_body(:,1),koncove_body(:,2),koncove_body(:,3),'Color',[0,0.4,0])
legend off
grid off

% Výpocet vzdalenosti koncovych bodu
l = (((robot2(1)-robot1(1))^2)+((robot2(2)-robot1(2))^2)+((robot2(3)-robot1(3))^2))^(1/2);

line_cent = [((robot2(1)-robot1(1))/2)+robot1(1),((robot2(2)-robot1(2))/2)+robot1(2),((robot2(3)-robot1(3))/2)+robot1(3)];

text(line_cent(1),line_cent(2),line_cent(3), sprintf(' L = %.2f', l), ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'top', ...
    'FontSize', 10, ...
    'FontWeight', 'bold', ...
    'Color','g');
