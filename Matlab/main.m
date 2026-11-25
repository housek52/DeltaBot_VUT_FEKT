%==========================================================================
% Název souboru:   main.m
% Autor:           Vit Fousek
% Verze:           1.0
% Datum:           7.11.2026
% Popis:          
%   Testovani kolizi deltabotu, jejichz pracovni prostory se protinaji.
%   Soubor slouzi k vykreseni situace dvou deltabotu s moznaosti jednoduche
%   zmeny jejich vzajemne pozice. Jednotlive urceni spravnosti pozice bude 
%   v jednotlivych funkcich, aby se na ne dalo samostatne a prehledne
%   podivat.
%==========================================================================



clc, clear variables, close all

rozmer = [50,370,50,500,50];    % [offset, rameno, offset od ramena, karbon tyc ,offset k konec bodu]
% pos = [-100,0,-400] ;              % [x,y,z]
% natazeni = [260,260,260];
% [pos(1),pos(2),pos(3)] = PrimaKinematika(rozmer,natazeni);
% [U,V,W] = InverzniKinematika(rozmer,pos);

% Vykresleni robotu a spojnice koncovych bodu
kolize = figure('Name', 'Kolize');
simulace(kolize, rozmer);

% kolize2 = figure('Name', 'Kolize');
% simulace(kolize2);

function simulace(fig, rozmer)
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
        'Min', -530, 'Max', -300, 'Value', -400, ...
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
        'Min', -530, 'Max', -300, 'Value', -400, ...
        'Position', [1200, 70, 300, 25], ...
        'Callback', @(src, event) zmenaSliderem());
    uicontrol('Style', 'text', 'Position', [1430, 520, 50, 20], 'String', 'Z2:');
    edtZ2 = uicontrol('Parent', fig, 'Style', 'edit', ...
        'String', '0.00', ... % Výchozí zobrazené číslo
        'Position', [1450, 500, 60, 25], ...
        'Callback', @(src, event) zmenaTextem());

    uicontrol('String', 'Export PDF', 'Callback', @plotButtonPushed);
    
    pos1_l = [0,0,-400];               % Vychozi poloha deltabotu
    pos2_l = [0,0,-400];
    [pos1_l,pos2_l] = vykresli(pos1_l, pos2_l, rozmer);

    function zmenaSliderem()
        % Aktualizuje text v políčku podle nové hodnoty ze slideru
        edtX1.String = sprintf('%.2f', sldX1.Value);
        edtY1.String = sprintf('%.2f', sldY1.Value);
        edtZ1.String = sprintf('%.2f', sldZ1.Value);
        edtX2.String = sprintf('%.2f', sldX2.Value);
        edtY2.String = sprintf('%.2f', sldY2.Value);
        edtZ2.String = sprintf('%.2f', sldZ2.Value);
        [pos1_l,pos2_l] = vykresli(pos1_l, pos2_l, rozmer);
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
        [pos1_l,pos2_l] = vykresli(pos1_l, pos2_l, rozmer);
    end

    function [pos1_l, pos2_l] = vykresli(pos1_l, pos2_l, rozmer)
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
        stred = [400,0,0];

        [robot1, jzd1] = vykresleni_deltabot(rozmer,pos1,pos1_l,[0,0,0],180);
        [robot2, jzd2] = vykresleni_deltabot(rozmer,pos2,pos2_l,stred,0,'k');

        koncove_body = [robot1;robot2];

        pos1_l(1) = -robot1(1);
        pos1_l(2) = -robot1(2);
        pos1_l(3) = robot1(3);
        pos2_l(1) = robot2(1)-400;
        pos2_l(2) = robot2(2);
        pos2_l(3) = robot2(3);
        assignin('base','koncove_body',koncove_body);

        legend off
        grid on

        l_base = 240;
        l_efekrot = rozmer(1);

        %% METODA 0: Vypocet vzdalenosti koncovych bodu jednoduchy
        % [l,e] = M0_vkb(koncove_body);

        %% METODA 1: Vypocet vzdalenosti koncovych bodu pooci elipsy
        elipsa_S = [l_base*0.75,0,0] + robot2;                             % stred posunut na kraj konstrukce
        r_min = 65;                                                        % vzdalenost bodu efektoru k elipse v hlavni ose

        a = r_min + l_base*0.75;                                           % poloosa elipsy v ose x
        b = l_base + 40;                                                   % poloosa elipsy v ose y
        t = pi/2:pi/50:3*pi/2;                                             % stupne pro vykresleni polovyny elipsy

        elipsa = [elipsa_S(1) + a*cos(t); elipsa_S(2) + b*sin(t);];        % vypocet elipsy v rovine xy
        elipsa(3,:) = ones(size(t))*elipsa_S(3);                           % urceni pozice elipsy v z

        plot3(elipsa(1,:),elipsa(2,:),elipsa(3,:), 'LineWidth',0.5,'Color','r');
        plot3(elipsa_S(1),elipsa_S(2),elipsa_S(3),'Color','k','LineStyle','none','Marker','x','MarkerSize',25);
        % view([0,0]) % pohled na rovinu xz
        % view([0,90])    % pohled na rovinu xy
        % view([90,0])    % pohled na rovinu yz

        % Spojnice koncový bod a počátek robota
        % zjednodušeně
        
        dx = stred(1)-robot2(1);
        dy = stred(2)-robot2(2);
        dz = stred(3)-robot2(3);

        % jednotkove vektory
        F = (dx^2+dy^2+dz^2)^(1/2);
        i = dx/F;
        j = dy/F;
        k = dz/F;

        % vypocet smernice x pro rozsireni poloosy a
        % pro urceni rozsirovani poloosy a urci spojnici nejblize k druhemu robotu
        if jzd2(2,1)<=jzd2(3,1)
            jOsX = 2;
        else
            jOsX = 3;
        end

        plot3(jzd2(:,1),jzd2(:,2),jzd2(:,3),'o','LineWidth',3);
        % plot3([-rozmer(1)*cosd(60)+koncove_body(2,1),jzd2(jOs,1)],[0,0],[koncove_body(2,3),jzd2(jOs,3)],'LineWidth',5)
        da = ((-rozmer(1)*cosd(60)+stred(1))-jzd2(jOsX,1))/F;
        assignin('base','da',da);

        jak_moc = 10;
        ze = robot2(3):k*jak_moc:stred(3); % od pozice z koncového bodu do počátku robata
        assignin('base','ze',ze);
        sz = numel(ze);
        se = numel(t);

        % vypocet smernice y pro rozsireni poloosy b
        db1 = (-rozmer(1)*sind(60)+koncove_body(2,2))-jzd2(2,2);
        db2 = (rozmer(1)*sind(60)+koncove_body(2,2))-jzd2(3,2);
        if abs(db1)>abs(db2)
            db = db1/F;
            jOsY = 2;
        else
            db = -db2/F;
            jOsY = 3;
        end

        % plot3([400,400],[-(-1)^jOsY*rozmer(1)*sind(60)+koncove_body(2,2),jzd2(jOsY,2)],[koncove_body(2,3),jzd2(jOsY,3)],'LineWidth',5)

        for c = 1:sz-1
            zp = ones(1,se)*ze(c);
            elipsa = [elipsa_S(1) + (a+da*jak_moc*c)*cos(t); elipsa_S(2) + (b+db*jak_moc*c)*sin(t);];
            plot3(elipsa(1,:)+(c*jak_moc*i),elipsa(2,:)+(c*jak_moc*j),zp, 'LineWidth',0.5,'Color','r');
        end

        plot3([robot2(1),stred(1)],[robot2(2),0],[robot2(3),0],'g');


    end

    function plotButtonPushed(src,event)
        exportgraphics(fig, 'graf_robota.pdf', 'ContentType', 'vector');
    end
end