%==========================================================================
% Název souboru:   vykresleni_deltabot.m
% Autor:           Ondřej Dušek
% Verze:           1.0
% Datum:           24.12.2024
% Popis:          
%   Vykreslí deltabota
%
% Vstupy:
%   - rozmery = rozměry deltabota
%   - konec = pozice koncového bodu
%
%==========================================================================
% Úprava pro detekci kolizí robotických systémů
% Autor:           Vít Fousek
% Datum:           6.11.2026
% Popis:
%     Přidání možnosti translace robota v prostoru a odeprání figure
%     (volání v main pro možnost volání pro více kreslení)
%     Vykresleni cele delky pohyblivych os
%
% Přidaný vstupy:
%     - translace = posunutí o x,y,z
%     - rotace = otočení okolo osy z robotu ve stupních
%     - barva = barva joku se vykreslí model
% Přidání výstupu:
%     - koncový bod robotu v souřadném systému celé oblasti
%==========================================================================

function [efektor] = vykresleni_deltabot(rozmer,konec,translace,rotace, barvaU, barvaV, barvaW)
%=================================UPRAVA===================================
arguments
    rozmer;
    konec;
    translace = [0,0,0];
    rotace = 0;
    barvaU = 'b';
    barvaV = barvaU;
    barvaW = barvaU;
end

R = [cosd(rotace), -sind(rotace); 
    sind(rotace),  cosd(rotace)];
%==========================================================================

d1 = rozmer(1);
d2 = rozmer(2);
d3 = rozmer(3);
d4 = rozmer(4);
d5 = rozmer(5);
alfa = 45;
x5 = konec(1);
y5 = konec(2);
z5 = konec(3);
[U, V, W] = InverzniKinematika([d1,d2,d3,d4,d5], [x5,y5,z5]);

u1 = struct( ...
    'x', [0, d1,            d1+U*sind(alfa),  d1+U*sind(45)+d3*cosd(alfa),            x5+d5,             x5], ...
    'y', [0, 0,             0,               0,                                    y5,               y5], ...
    'z', [0, 0,             U*cosd(alfa),    -d3*sind(45)+U*cosd(alfa),               z5,                z5]);
v1 = struct( ...
    'x', [0, -cosd(60)*d1, -cosd(60)*(d1+V*sind(alfa)), -cosd(60)*(d1+V*sind(alfa)+d3*cosd(alfa)), x5-d5*cosd(60), x5], ...
    'y', [0, -sind(60)*d1, -sind(60)*(d1+V*sind(alfa)), -sind(60)*(d1+V*sind(alfa)+d3*cosd(alfa)), y5-d5*sind(60), y5], ...
    'z', [0, 0,             V*cosd(alfa),                -d3*sind(alfa)+V*cosd(alfa),               z5,             z5]);
w1 = struct( ...
    'x', [0, -cosd(60)*d1, -cosd(60)*(d1+W*sind(alfa)), -cosd(60)*(d1+W*sind(alfa)+d3*cosd(alfa)), x5-d5*cosd(60), x5], ...
    'y', [0, sind(60)*d1,   sind(60)*(d1+W*sind(alfa)),  sind(60)*(d1+W*sind(alfa)+d3*cosd(alfa)), y5+d5*sind(60), y5], ...
    'z', [0, 0,             W*cosd(alfa),               -d3*sind(alfa)+W*cosd(alfa),               z5,             z5]);
u1.z = u1.z;
v1.z = v1.z;
w1.z = w1.z;

%=================================UPRAVA===================================
% Rotace vykresleného robotu
rotovaniU = R*[u1.x;u1.y];
rotovaniV = R*[v1.x;v1.y];
rotovaniW = R*[w1.x;w1.y];
% Aplikace rotace na souřadnice ramen
u1.x = rotovaniU(1,:);
u1.y = rotovaniU(2,:);
v1.x = rotovaniV(1,:);
v1.y = rotovaniV(2,:);
w1.x = rotovaniW(1,:);
w1.y = rotovaniW(2,:);
% Translace vykresleni robotu
u1.x = u1.x + translace(1);
u1.y = u1.y + translace(2);
u1.z = u1.z + translace(3);
v1.x = v1.x + translace(1);
v1.y = v1.y + translace(2);
v1.z = v1.z + translace(3);
w1.x = w1.x + translace(1);
w1.y = w1.y + translace(2);
w1.z = w1.z + translace(3);

rotU = (R*[d1+270*sind(alfa);0]);
rotV = (R*[-cosd(60)*(d1+270*sind(alfa));-sind(60)*(d1+270*sind(alfa))]);
rotW = (R*[-cosd(60)*(d1+270*sind(alfa));sind(60)*(d1+270*sind(alfa))]);

%==========================================================================

% col = [0.2,0.6,0.8]
% red = [1,0,0];
% green = [0,1,0];
% blue = [0,0,1];
% transp = 0.15;
% polomer = d4;

% linex = [d1+d2*sind(45)+d3*cosd(45), d1+0*sind(45)+d3*cosd(45)];
% liney = [0,0];
% linez = [-d3*sind(45)+d2*cosd(45), -d3*sind(45)+0*cosd(45)];
% linez = -linez
% center1 = [u.x(5), u.y(5), u.z(5)];
% center2 = [v.x(4)+cosd(60)*d5, v.y(4)+sind(60)*d5, v.z(4)];
% center3 = [w.x(4)+cosd(60)*d5, w.y(4)-sind(60)*d5, w.z(4)];
% [x_1, y_1, z_1] = sphere;
% x_1 = polomer * x_1 + center1(1);
% y_1 = polomer * y_1 + center1(2);
% z_1 = polomer * z_1 + center1(3);
% [x_2, y_2, z_2] = sphere;
% x_2 = polomer * x_2 + center2(1);
% y_2 = polomer * y_2 + center2(2);
% z_2 = polomer * z_2 + center2(3);
% [x_3, y_3, z_3] = sphere;
% x_3 = polomer * x_3 + center3(1);
% y_3 = polomer * y_3 + center3(2);
% z_3 = polomer * z_3 + center3(3);

% figure

view(3)
%=================================UPRAVA===================================
% Vykresleni kompletni delky os
plot3([u1.x(2),rotU(1,:)+translace(1)], ...
    [u1.y(2),rotU(2,:)+translace(2)], ...
    [u1.z(2),(270*cosd(alfa))+translace(3)], ...
    'w',LineWidth=1)
hold on
plot3([v1.x(2),rotV(1,:)+translace(1)], ...
    [v1.y(2),rotV(2,:)+translace(2)], ...
    [v1.z(2),(270*cosd(alfa))+translace(3)], ...
    'w',LineWidth=1)
plot3([w1.x(2),rotW(1,:)+translace(1)], ...
    [w1.y(2),rotW(2,:)+translace(2)], ...
    [w1.z(2),(270*cosd(alfa))+translace(3)], ...
    'w',LineWidth=1)
%==========================================================================


plot3(u1.x, u1.y, u1.z, barvaU, LineWidth=2, DisplayName="Rameno U")
plot3(v1.x, v1.y, v1.z, barvaV, LineWidth=2, DisplayName="Rameno V")
plot3(w1.x, w1.y, w1.z, barvaW, LineWidth=2, DisplayName="Rameno W")
% plot3(linex,liney,linez,'k-', LineWidth=4);
% surf(x_1, y_1, z_1, 'FaceColor', [0.3,0.3,0.8], 'FaceAlpha', transp, "LineStyle",":");
% surf(x_2, y_2, z_2, 'FaceColor', [0.3,0.8,0.3], 'FaceAlpha',transp, "LineStyle",":");
% surf(x_3, y_3, z_3, 'FaceColor', [0.3,0.3,0.8], 'FaceAlpha',transp, "LineStyle",":");
axis("equal")
% scatter3(u1.x(1), u1.y(1), u1.z(1),'x', 'w', 'HandleVisibility', 'off');
% scatter3(u1.x(6), u1.y(6), u1.z(6),'o', 'filled', 'w', 'HandleVisibility', 'off');
xlabel x[mm]
ylabel y[mm]
zlabel z[mm]
title("Deltabot")
legend('show')
% exportgraphics(fig, "Prima.png", "Resolution",600)

%=================================UPRAVA===================================
efektor = [u1.x(6), u1.y(6), u1.z(6)];
%==========================================================================
end