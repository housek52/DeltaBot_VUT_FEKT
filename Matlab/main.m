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

    % Posuvnik X
    uicontrol('Style', 'text', 'Position', [50, 165, 200, 20], 'String', 'Posun robota X:');
    sldX = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [100, 140, 300, 25], ...
        'Callback', @(src, event) vykresli());
    
    % Posuvnik Y
    uicontrol('Style', 'text', 'Position', [50, 65, 200, 20], 'String', 'Posun robota Y:');
    sldY = uicontrol('Parent', fig, 'Style', 'slider', ...
        'Min', -400, 'Max', 400, 'Value', 0, ...
        'Position', [100, 40, 300, 25], ...
        'Callback', @(src, event) vykresli());

    vykresli();

    function vykresli()
        rozmer = [50,370,50,500,50];    % Rozmery deltabotu
        pos = [0,0,-400];               % Vychozi poloha deltabotu
        % Cteni slideru
        pos(1) = sldX.Value;
        pos(2) = sldY.Value;

        % Vycisteni predchoziho kresleni
        cla(ax);
        hold(ax, 'on')
        % Vykresli dva deltaboty
        robot1 = vykresleni_deltabot(rozmer,pos,[0,0,0],180);
        robot2 = vykresleni_deltabot(rozmer,pos,[400,0,0],0,'c');
        koncove_body = [robot1;robot2];
        legend off
        grid off

        % Vypocet vzdalenosti koncovych bodu
        l = (((robot2(1)-robot1(1))^2)+((robot2(2)-robot1(2))^2)+((robot2(3)-robot1(3))^2))^(1/2);
    
        % Urci barvu spojnice podle vzdalenosti
        if l<100
            barvaT = 'r';
            barvaL = [0.7,0,0];
        else
            barvaT = 'g';
            barvaL = [0,0.5,0];
        end

        % Vykresli spojnici koncovych bodu
        plot3(koncove_body(:,1),koncove_body(:,2),koncove_body(:,3), 'o-','MarkerFaceColor', 'w', 'MarkerEdgeColor', 'w', 'Color',barvaL)
        % Vykresli vzdalenost koncovych bodu u prostredku spojnice
        line_cent = [((robot2(1)-robot1(1))/2)+robot1(1),((robot2(2)-robot1(2))/2)+robot1(2),((robot2(3)-robot1(3))/2)+robot1(3)];
        text(line_cent(1),line_cent(2),line_cent(3), sprintf(' L = %.2f', l), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top', ...
            'FontSize', 10, ...
            'FontWeight', 'bold', ...
            'Color',barvaT);
    end
end