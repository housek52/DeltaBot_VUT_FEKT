%==========================================================================
% Název souboru:   main.m
% Autor:           Vit Fousek
% Verze:           1.0
% Datum:           7.11.2026
% Popis:          
%   Testovani kolizi deltabotu, jejichz pracovni prostory se protinaji.
%==========================================================================



clc, clear variables, close all

% rozmer = [50,370,50,500,50];    % [offset, rameno, offset od ramena, karbon tyc ,offset k konec bodu]
% pos = [-100,0,-400] ;              % [x,y,z]
% natazeni = [260,260,260];
% [pos(1),pos(2),pos(3)] = PrimaKinematika(rozmer,natazeni);
% [U,V,W] = InverzniKinematika(rozmer,pos);

% Vykresleni robotu a spojnice koncovych bodu
kolize = figure('Name', 'Kolize');
simulace(kolize);

% kolize2 = figure('Name', 'Kolize');
% simulace(kolize2);

function simulace(fig)
    % Nastaveni vykresleni
    ax = axes('Parent', fig);
    ax.XLimMode = "manual";
    ax.YLimMode = "manual";
    ax.ZLimMode = "manual";
    ax.XLim = [-500,900];
    ax.YLim = [-500,500];
    ax.ZLim = [-500,200];
    axis(ax, 'equal')


    % Cteni pozice robota 1
    % Posuvnik X
    uicontrol('Style', 'text', 'Position', [50, 300, 100, 20], 'String', 'Posun robota X:');
    sldX1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [50, 270, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [30, 520, 50, 20], 'String', 'X1:');
    edtX1 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [50, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());
    

    % Posuvnik Y
    uicontrol('Style', 'text', 'Position', [50, 200, 100, 20], 'String', 'Posun robota Y:');
    sldY1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [50, 170, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [130, 520, 50, 20], 'String', 'Y1:');
    edtY1 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [150, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());
    
    % Posuvnik Z
    uicontrol('Style', 'text', 'Position', [50, 100, 100, 20], 'String', 'Posun robota Z:');
    sldZ1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -500, 'Max', -176, 'Value', -400, ...
        'Position', [50, 70, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [230, 520, 50, 20], 'String', 'Z1:');
    edtZ1 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [250, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());

    % Cteni pozice robota 2
    % Posuvnik X
    uicontrol('Style', 'text', 'Position', [1200, 300, 100, 20], 'String', 'Posun robota X:');
    sldX2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [1200, 270, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [1230, 520, 50, 20], 'String', 'X2:');
    edtX2 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [1250, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());

    % Posuvnik Y
    uicontrol('Style', 'text', 'Position', [1200, 200, 100, 20], 'String', 'Posun robota Y2:');
    sldY2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [1200, 170, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [1330, 520, 50, 20], 'String', 'Y2:');
    edtY2 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [1350, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());

    % Posuvnik Z
    uicontrol('Style', 'text', 'Position', [1200, 100, 100, 20], 'String', 'Posun robota Z2:');
    sldZ2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -500, 'Max', -176, 'Value', -400, ...
        'Position', [1200, 70, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [1430, 520, 50, 20], 'String', 'Z2:');
    edtZ2 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [1450, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());

    uicontrol('String', 'Export PDF', 'Callback', @plotButtonPushed);

    vykresli();

    function zmenaSliderem()
        % Aktualizuje text v políčku podle nové hodnoty ze slideru
        edtX1.String = sprintf('%.2f', sldX1.Value);
        edtY1.String = sprintf('%.2f', sldY1.Value);
        edtZ1.String = sprintf('%.2f', sldZ1.Value);
        edtX2.String = sprintf('%.2f', sldX2.Value);
        edtY2.String = sprintf('%.2f', sldY2.Value);
        edtZ2.String = sprintf('%.2f', sldZ2.Value);
        vykresli();
    end

    % Když uživatel ručně přepíše číslo v políčku:
    function zmenaTextem()
        % Převede zadaný text na číslo (str2double)
        x1 = str2double(edtX1.String);
        y1 = str2double(edtY1.String);
        z1 = str2double(edtZ1.String);
        x2 = str2double(edtX2.String);
        y2 = str2double(edtY2.String);
        z2 = str2double(edtZ2.String);

        % Kontrola, zda uživatel nezadal text nebo blbost (NaN)
        if isnan(x1)
            edtX1.String = sprintf('%.2f', sldX1.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            x1 = min(max(x1, sldX1.Min), sldX1.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldX1.Value = x1;
            edtX1.String = sprintf('%.2f', x1);
        end
        if isnan(y1)
            edtY1.String = sprintf('%.2f', sldY1.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            y1 = min(max(y1, sldY1.Min), sldY1.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldY1.Value = y1;
            edtY1.String = sprintf('%.2f', y1);
        end
        if isnan(z1)
            edtZ1.String = sprintf('%.2f', sldZ1.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            z1 = min(max(z1, sldZ1.Min), sldZ1.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldZ1.Value = z1;
            edtZ1.String = sprintf('%.2f', z1);
        end

        if isnan(x2)
            edtX2.String = sprintf('%.2f', sldX2.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            x2 = min(max(x2, sldX2.Min), sldX2.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldX2.Value = x2;
            edtX2.String = sprintf('%.2f', x2);
        end
        if isnan(y2)
            edtY2.String = sprintf('%.2f', sldY2.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            y2 = min(max(y2, sldY2.Min), sldY2.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldY2.Value = y2;
            edtY2.String = sprintf('%.2f', y2);
        end
        if isnan(z2)
            edtZ2.String = sprintf('%.2f', sldZ2.Value); % Vrátí předchozí platnou hodnotu
        else
            % Omezí zadané číslo na rozsah slideru (Min az Max)
            z2 = min(max(z2, sldZ2.Min), sldZ2.Max);
            % Nastaví slider i vyčištěný text v políčku
            sldZ2.Value = z2;
            edtZ2.String = sprintf('%.2f', z2);
        end
        vykresli();
    end

    function vykresli()
        rozmer = [50,370,50,500,50];    % Rozmery deltabotu
        pos1 = [0,0,-0];               % Vychozi poloha deltabotu
        pos2 = [0,0,0];  
        % Cteni slideru
        pos1(1) = sldX1.Value;
        pos1(2) = sldY1.Value;
        pos1(3) = sldZ1.Value;
        pos2(1) = sldX2.Value;
        pos2(2) = sldY2.Value;
        pos2(3) = sldZ2.Value;

        % Vycisteni predchoziho kresleni
        cla(ax);
        hold(ax, 'on')
        % Vykresli dva deltaboty
        robot1 = vykresleni_deltabot(rozmer,pos1,[0,0,0],180);
        robot2 = vykresleni_deltabot(rozmer,pos2,[400,0,0],0,'k');
        koncove_body = [robot1;robot2];
        legend off
        grid on

        % Vypocet vzdalenosti koncovych bodu
        l = (((robot2(1)-robot1(1))^2)+((robot2(2)-robot1(2))^2)+((robot2(3)-robot1(3))^2))^(1/2);
    
        % Urci barvu spojnice podle vzdalenosti
        if l<150
            barvaT = 'r';
            barvaL = 'r';
        else
            barvaT = [0,0.7,0];
            barvaL = [0,0.7,0];
        end

        % Vykresli spojnici koncovych bodu
        plot3(koncove_body(:,1),koncove_body(:,2),koncove_body(:,3), 'o-','MarkerFaceColor', barvaL, 'MarkerEdgeColor', barvaL, 'Color',barvaL)
        % Vykresli vzdalenost koncovych bodu u prostredku spojnice
        line_cent = [((robot2(1)-robot1(1))/2)+robot1(1),((robot2(2)-robot1(2))/2)+robot1(2),((robot2(3)-robot1(3))/2)+robot1(3)];
        text(line_cent(1),line_cent(2),line_cent(3), sprintf(' L = %.2f', l), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Color',barvaT);
        % title("Vzdálenost koncových bodů",Color='k')
    end

    function plotButtonPushed(src,event)
        exportgraphics(fig, 'graf_robota.pdf', 'ContentType', 'vector');
    end
end