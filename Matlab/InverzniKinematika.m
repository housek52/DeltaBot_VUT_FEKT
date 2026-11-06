%==========================================================================
% Název souboru:   InverzniKinematika.m
% Autor:           Ondřej Dušek
% Verze:           1.2
% Datum:           26.12.2024
% Popis:          
%   Výpočet inverzní kinematiky deltabota
%
% Vstupy:
%   - rozmery = rozměry deltabota
%   - konec = souřadnice koncového bodu
%
% Výstupy:
%   - natažení ramen [U, V, W]
%
% verze
% 1.0 - initial
% 1.1 - přidání varování nemožné pozice
% 1.2 - odebrání substitucí, funkce je čistě rovnice
%==========================================================================

function [U, V, W] = InverzniKinematika(rozmery,konec)
    d1 = rozmery(1);
    d2 = rozmery(2);
    d3 = rozmery(3);
    d4 = rozmery(4);
    d5 = rozmery(5);
    x5 = konec(1);
    y5 = konec(2);
    z5 = konec(3);

    U = (2^(1/2)*(d5 - d1 + x5 + z5 + (- d1^2 - 2*2^(1/2)*d1*d3 + 2*d1*d5 + 2*d1*x5 - 2*d1*z5 - 2*d3^2 + 2*2^(1/2)*d3*d5 + 2*2^(1/2)*d3*x5 - 2*2^(1/2)*d3*z5 + 2*d4^2 - d5^2 - 2*d5*x5 + 2*d5*z5 - x5^2 + 2*x5*z5 - 2*y5^2 - z5^2)^(1/2)))/2;
    V = (2^(1/2)*d5)/2 - (2^(1/2)*d1)/2 - (2^(1/2)*x5)/4 - (6^(1/2)*y5)/4 + (2^(1/2)*z5)/2 + (2^(1/2)*(- 4*d1^2 - 8*2^(1/2)*d1*d3 + 8*d1*d5 - 4*d1*x5 - 4*3^(1/2)*d1*y5 - 8*d1*z5 - 8*d3^2 + 8*2^(1/2)*d3*d5 - 4*2^(1/2)*d3*x5 - 4*6^(1/2)*d3*y5 - 8*2^(1/2)*d3*z5 + 8*d4^2 - 4*d5^2 + 4*d5*x5 + 4*3^(1/2)*d5*y5 + 8*d5*z5 - 7*x5^2 + 2*3^(1/2)*x5*y5 - 4*x5*z5 - 5*y5^2 - 4*3^(1/2)*y5*z5 - 4*z5^2)^(1/2))/4;
    W = (2^(1/2)*d5)/2 - (2^(1/2)*d1)/2 - (2^(1/2)*x5)/4 + (6^(1/2)*y5)/4 + (2^(1/2)*z5)/2 + (4*d1*d5 - 2*d1*x5 + 2*d5*x5 - 4*d1*z5 + 4*d5*z5 - 2*x5*z5 - 2*d1^2 - 4*d3^2 + 4*d4^2 - 2*d5^2 - (7*x5^2)/2 - (5*y5^2)/2 - 2*z5^2 - 4*2^(1/2)*d1*d3 + 4*2^(1/2)*d3*d5 - 2*2^(1/2)*d3*x5 + 2*3^(1/2)*d1*y5 - 2*3^(1/2)*d5*y5 + 2*6^(1/2)*d3*y5 - 4*2^(1/2)*d3*z5 - 3^(1/2)*x5*y5 + 2*3^(1/2)*y5*z5)^(1/2)/2;

    realiz = U > d2 || U < 0 || V > d2 || V < 0 || W > d2 || W < 0;
    if realiz
        warning('Pozice (%.2f, %.2f, %.2f) není dosažitelná.', ...
            x5, y5, z5);
        warning('Pozice hledána pro natezeni ((%.2f, %.2f, %.2f).', ...
            U, V, W);
        return;
    end
end