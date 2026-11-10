%==========================================================================
% Název souboru:   main.m
% Autor:           Vit Fousek
% Verze:           1.0
% Datum:           7.11.2026
% Popis:          
%   Testovani kolizi deltabotu, jejichz pracovni prostory se protinaji.
%   
%==========================================================================



clc, clear variables, close all

% rozmer = [50,370,50,500,50];    % [offset, rameno, offset od ramena, karbon tyc ,offset k konec bodu]
% pos = [-100,0,-400] ;              % [x,y,z]
% natazeni = [260,260,260];
% [pos(1),pos(2),pos(3)] = PrimaKinematika(rozmer,natazeni);
% [U,V,W] = InverzniKinematika(rozmer,pos);

% Vykresleni robotu a spojnice koncovych bodu
simulace();

function simulace()
    fig = figure('Name', 'Kolize');
    ax = axes('Parent', fig);
    ax.XLimMode = "manual";
    ax.YLimMode = "manual";
    ax.ZLimMode = "manual";
    ax.XLim = [-500,900];
    ax.YLim = [-500,500];
    ax.ZLim = [-500,200];
    axis(ax, 'equal')

    fig = gcf;
    fig.Color = 'w';
    ax = gca;
    ax.Color = 'w';
    ax.XColor = 'k'; ax.YColor = 'k'; ax.ZColor = 'k';
    grid on;

    % con = figure('Name', 'Ovladani');

    % Robot 1
    % Posuvnik X
    uicontrol('Style', 'text', 'Position', [50, 300, 100, 20], 'String', 'Posun robota X:');
    sldX1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [50, 270, 300, 25], ...
        'Callback', @(src, event) vykresli());
    

    % Posuvnik Y
    uicontrol('Style', 'text', 'Position', [50, 200, 100, 20], 'String', 'Posun robota Y:');
    sldY1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [50, 170, 300, 25], ...
        'Callback', @(src, event) vykresli());
    
    % Posuvnik Z
    uicontrol('Style', 'text', 'Position', [50, 100, 100, 20], 'String', 'Posun robota Z:');
    sldZ1 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -500, 'Max', -176, 'Value', -400, ...
        'Position', [50, 70, 300, 25], ...
        'Callback', @(src, event) vykresli());

    % Robot 2
    % Posuvnik X
    uicontrol('Style', 'text', 'Position', [1200, 300, 100, 20], 'String', 'Posun robota X:');
    sldX2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [1200, 270, 300, 25], ...
        'Callback', @(src, event) vykresli());

    % Posuvnik Y
    uicontrol('Style', 'text', 'Position', [1200, 200, 100, 20], 'String', 'Posun robota Y:');
    sldY2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [1200, 170, 300, 25], ...
        'Callback', @(src, event) vykresli());

    % Posuvnik Z
    uicontrol('Style', 'text', 'Position', [1200, 100, 100, 20], 'String', 'Posun robota Z:');
    sldZ2 = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -500, 'Max', -176, 'Value', -400, ...
        'Position', [1200, 70, 300, 25], ...
        'Callback', @(src, event) vykresli());

    uicontrol('String', 'Export PDF', 'Callback', @plotButtonPushed);

    vykresli();

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
        title("Vzdálenost koncových bodů",Color='k')
    end

    function plotButtonPushed(src,event)
        exportgraphics(fig, 'graf_robota.pdf', 'ContentType', 'vector');
    end
end