%==========================================================================
% Název souboru:   M0_vkb.m
% Autor:           Vit Fousek
% Verze:           1.0
% Datum:           7.11.2026
% Popis:
%   Metoda jednoducheho zjisteni vdalenosti koncovych bodu. Prostor
%   rozdelen na 3 oblasti: koncove bod daleko od sebe bez krizeni, koncove
%   body blizko u sebe, koncove body za sebou. Metoda nezohlednuje spojnice
%   jezdcu os s efektorem.
%==========================================================================

function [l,e] = M0_vkb(koncove_body)
    robot1 = koncove_body(1,:);
    robot2 = koncove_body(2,:);
    
    l = (((robot2(1)-robot1(1))^2)+((robot2(2)-robot1(2))^2)+((robot2(3)-robot1(3))^2))^(1/2);
    % assignin('base','l',l);
    
    kb_x = robot2(1)-robot1(1);
    kb_y = robot2(2)-robot1(2);

    % urceni korektni pozice
    % pokud robot1 saha za robota2, musi byt rozdil v y
    if kb_x < 0
        if 0.5*abs(kb_x)+200>abs(kb_y)
            e = 1;
        else
            e = 0;
        end
    elseif kb_x < 60 && abs(kb_y) > 100
        if 2.5*abs(kb_x)+200 > abs(kb_y)
            e = 1;
        else
            e = 0;
        end
    elseif kb_x < 60
        e = 1;
    else
        e = 0;
    end
    % assignin('base','e',e);

    if e == 1
        barvaT = 'r';
        barvaL = 'r';
    else
        barvaT = [0,0.7,0];
        barvaL = [0,0.7,0];
    end

    % Vykresli spojnici koncovych bodu
    plot3(koncove_body(:,1),koncove_body(:,2),koncove_body(:,3), 'o-','MarkerFaceColor', barvaL, 'MarkerEdgeColor', barvaL, 'Color',barvaL)
    title(sprintf("Vzdálenost koncových bodů L = %.2f", l),Color=barvaT)
end