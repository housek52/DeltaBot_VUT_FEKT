%==========================================================================
% Název souboru:    vz_kon_b.m
% Autor:            Vít Fousek
% Datum:            15. 11. 2026
% Popis:
%       Základní princip, na kterém zakládám detekci kolize vzdáleností
%       koncových bodů deltabotů.
%==========================================================================

clc, close all, clear variables

% Parametry deltabota
l_base = 190;
l_efekrot = 50;

% Vypocet pro zakladnu deltabota
r1 = [l_base*cosd(120), l_base*sind(120)];
r2 = [r1(1), -r1(2)];
r3 = [l_base, 0];
% Vypocet pro efektor deltabota
e1 = [l_efekrot*cosd(120), l_efekrot*sind(120)];
e2 = [e1(1), -e1(2)];
e3 = [l_efekrot, 0];

% Vypocet bezpecne vzdalenosti okolo efektrou
r = l_efekrot + 10;
th = 0:pi/50:2*pi;
x_c = r*cos(th);
y_c = r*sin(th);

% Vypocet bezpecne oblasti za efektorem deltabotu
x = 0:1:200;
y = x+r;

fig = figure('Name','Limity')
hold on
plot([0, r1(1)]+400, [0, r1(2)], 'k', 'LineStyle',':','LineWidth',2);
plot([0, r2(1)]+400, [0, r2(2)], 'k', 'LineStyle',':','LineWidth',2);
plot([0, r3(1)]+400, [0, r3(2)], 'k', 'LineStyle',':','LineWidth',2);
plot([0, e1(1)]+400, [0, e1(2)], 'k','LineWidth',2);
plot([0, e2(1)]+400, [0, e2(2)], 'k','LineWidth',2);
plot([0, e3(1)]+400, [0, e3(2)], 'k','LineWidth',2);
plot(x_c+400,y_c, 'r');
plot(x+400,y,'r');
plot(x+400,-y,'r');
axis('equal')
% exportgraphics(fig, 'limit.pdf', 'ContentType', 'vector');

