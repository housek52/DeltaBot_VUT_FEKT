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
l_base = 240;
l_efekrot = 50;

% Vypocet pro zakladnu deltabota
r = [l_base*cosd(120), l_base*sind(120);
    l_base*cosd(120), -l_base*sind(120);
    l_base, 0];
% Vypocet pro efektor deltabota
e = [l_efekrot*cosd(120), l_efekrot*sind(120);
    l_efekrot*cosd(120), -l_efekrot*sind(120);
    l_efekrot, 0];

fig = figure;
hold on
axis('equal')
axis([-200 500 -300 300])

% Vykresleni deltabota
l_r = plot([0, r(1,1)], [0, r(1,2)], 'k', 'LineStyle',':','LineWidth',3);
    plot([0, r(2,1)], [0, r(2,2)], 'k', 'LineStyle',':','LineWidth',3);
    plot([0, r(3,1)], [0, r(3,2)], 'k', 'LineStyle',':','LineWidth',3);
l_e = plot([0, e(1,1)], [0, e(1,2)], 'k','LineWidth',3);
    plot([0, e(2,1)], [0, e(2,2)], 'k','LineWidth',3);
    plot([0, e(3,1)], [0, e(3,2)], 'k','LineWidth',3);
% % Vypocet bezpecne vzdalenosti okolo efektrou
% r = l_efekrot + 10;
% th = 0:pi/50:2*pi;
% x_c = r*cos(th);
% y_c = r*sin(th);
% % Vypocet bezpecne oblasti za efektorem deltabotu
% x = 0:1:200;
% y = 0.5*x+200;
% % Vykresleni primek limitu
% plot(x_c,y_c, 'r');
% plot(x,y,'r');
% plot(x,-y,'r');
% plot([-60, -60], [-50, 50], 'r', 'LineWidth', 0.5)
% a = 2.5;
% b = 200;
% fplot(@(x) a*x + b, [-60, 0], 'LineWidth', 0.5, 'Color', 'r');
% fplot(@(x) -a*x - b, [-60, 0], 'LineWidth', 0.5, 'Color', 'r');


% Elipsa Ohnisko v [0,0]

elipsa_S = [l_base*0.75,0];             % stred posunut na kraj konstrukce
r_min = 65;                     % vzdalenost bodu efektoru k elipse v hlavni ose
a = r_min + l_base*0.75;
b = l_base + 40;
t = pi/2:pi/50:3*pi/2;
elipsa = [elipsa_S(1) + a*cos(t); elipsa_S(2) + b*sin(t)];
l_el = plot(elipsa(1,:),elipsa(2,:), 'LineWidth',2,'Color','r');
l_elS = plot(elipsa_S(1),elipsa_S(2),'Color','k','LineStyle','none','LineWidth',2,'Marker','x','MarkerSize',25);

% 1 = (x-m)^2/a^2 + (y-n)^2/b^2

pos = find(abs(elipsa(1,:) - elipsa_S(1)) < 1e-9);
dx = elipsa(1,pos(2)) - elipsa(1,pos(2)-1);
dy = elipsa(2,pos(2)) - elipsa(2,pos(2)-1);
smer = abs(dy/dx);
offset = elipsa(2,pos(1)) - smer*elipsa(1,pos(1));
X_k = [elipsa_S(1), elipsa_S(1)+a];
Y_k = [elipsa(2,pos(1)),0];
Y_k(2) = smer*X_k(2) + offset;

plot(X_k,Y_k, 'LineWidth',2,'Color','r')
plot(X_k,-Y_k, 'LineWidth',2,'Color','r')

[X,Y] = meshgrid(-300:2:600,-300:2:300);
p = zeros(size(Y,1),size(X,2));
for i = 1:size(X,2)
    for j = 1:size(Y,1)
        if X(1,i)<elipsa_S(1)
            if (X(1,i)-elipsa_S(1))^2/(a^2) + ((Y(j,1)-elipsa_S(2))^2)/(b^2) > 1
                p(j,i) = true;
            else
                p(j,i) = false;
            end
        else 
            if abs(Y(j,1)) > smer*X(1,i) + offset
                p(j,i) = true;
            else
                p(j,i) = false;
            end
        end
    end
end

% 1 = (x-m)^2/a^2 + (y-n)^2/b^2         % rovnice elipsy
% p = ((X-elipsa_S(1)).^2)/(a^2) + ((Y-elipsa_S(2)).^2)/(b^2) > 1;
p = double(p);
colormap([1,0,0; 0,1,0]);
clim([0,1])
surf(X,Y,p,'EdgeColor', 'none', 'FaceAlpha', 0.3)

lgd = legend([l_r,l_e,l_el,l_elS],{'Konstrukce os','Efektor','Limit povolené pozice','Střed elipsy'});
fontsize(16, "points");
lgd.Location = "northeast";
lgd.Position(1) = lgd.Position(1) - 0.02;
lgd.Position(2) = lgd.Position(2) - 0.01;
exportgraphics(fig, 'limit.pdf', 'ContentType', 'vector');