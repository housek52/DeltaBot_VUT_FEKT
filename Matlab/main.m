clc, clear variables, close all

rozmer = [50,370,50,500,50];    % [offset, rameno, offset od ramena, karbon tyc ,offset k konec bodu]
pos = [0,0,-400] ;            % [x,y,z]

natazeni = [260,260,260];
[pos(1),pos(2),pos(3)] = PrimaKinematika(rozmer,natazeni);
[U,V,W] = InverzniKinematika(rozmer,pos);

figure
hold on
vykresleni_deltabot(rozmer,pos,[0,0,0],180)
vykresleni_deltabot(rozmer,pos,[300,0,0])