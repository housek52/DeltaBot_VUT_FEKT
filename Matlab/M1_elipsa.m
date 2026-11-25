function M1_elipsa(robot1, robot2, jzd2, stred, l_base, l_efektor)
%M1_ELIPSA Summary of this function goes here
%   Detailed explanation goes here
    elipsa_S = [l_base*0.75,0,0] + robot2;                                  % stred posunut na kraj konstrukce
    r_min = 65;                                                             % vzdalenost bodu efektoru k elipse v hlavni ose

    a = r_min + l_base*0.75;                                                % poloosa elipsy v ose x
    b = l_base + 40;                                                        % poloosa elipsy v ose y
    t = pi/2:pi/50:3*pi/2;                                                  % stupne pro vykresleni polovyny elipsy

    elipsa = [elipsa_S(1) + a*cos(t); elipsa_S(2) + b*sin(t);];             % vypocet elipsy v rovine xy
    elipsa(3,:) = ones(size(t))*elipsa_S(3);                                % urceni pozice elipsy v z

    plot3(elipsa(1,:),elipsa(2,:),elipsa(3,:), 'LineWidth',0.5,'Color','r');
    plot3(elipsa_S(1),elipsa_S(2),elipsa_S(3),'Color','k','LineStyle','none','Marker','x','MarkerSize',25);     % vykresli stred elipsy
    view([0,0])     % pohled na rovinu xz
    % view([0,90])    % pohled na rovinu xy
    % view([90,0])    % pohled na rovinu yz

    % Spojnice koncový bod a počátek robota
    % zjednodušeně        
    % dx = stred(1)-robot2(1);
    % dy = stred(2)-robot2(2);
    % dz = stred(3)-robot2(3);

    % vypocet teziste jezdcu
    % stredy x
    x1 = jzd2(1,1)+(jzd2(2,1)-jzd2(1,1))/2;
    x2 = jzd2(2,1)+(jzd2(3,1)-jzd2(2,1))/2;
    x3 = jzd2(3,1)+(jzd2(1,1)-jzd2(3,1))/2;
    % stredy y
    y1 = jzd2(1,2)+(jzd2(2,2)-jzd2(1,2))/2;
    y2 = jzd2(2,2)+(jzd2(3,2)-jzd2(2,2))/2;
    y3 = jzd2(3,2)+(jzd2(1,2)-jzd2(3,2))/2;
    % stredy z
    z1 = jzd2(1,3)+(jzd2(2,3)-jzd2(1,3))/2;
    z2 = jzd2(2,3)+(jzd2(3,3)-jzd2(2,3))/2;
    z3 = jzd2(3,3)+(jzd2(1,3)-jzd2(3,3))/2;

    % dleky
    l1 = ((jzd2(2,1)-jzd2(1,1))^2 + (jzd2(2,2)-jzd2(1,2))^2 + (jzd2(2,3)-jzd2(1,3))^2)^(1/2);
    l2 = ((jzd2(3,1)-jzd2(2,1))^2 + (jzd2(3,2)-jzd2(2,2))^2 + (jzd2(3,3)-jzd2(2,3))^2)^(1/2);
    l3 = ((jzd2(1,1)-jzd2(3,1))^2 + (jzd2(1,2)-jzd2(3,2))^2 + (jzd2(1,3)-jzd2(3,3))^2)^(1/2);

    xT = (x1*l1+x2*l2+x3*l3)/(l1+l2+l3);
    yT = (y1*l1+y2*l2+y3*l3)/(l1+l2+l3);
    zT = (z1*l1+z2*l2+z3*l3)/(l1+l2+l3);

    dx = xT-robot2(1);
    dy = yT-robot2(2);
    dz = zT-robot2(3);

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

    % plot3(jzd2(:,1),jzd2(:,2),jzd2(:,3),'o','LineWidth',3);                 % vykresli pozici jezdcu
    % plot3(xT,yT,zT,'o')                                                     % vykresli teziste trojuhelniku jezdcu

    % Vykresleni primky urceni smernice pro zmenu poloosy a
    % plot3([-l_efektor*cosd(60)+robot2(1),jzd2(jOsX,1)],[0,0],[robot2(3),jzd2(jOsX,3)],'LineWidth',5)
    da = ((-l_efektor*cosd(60)+stred(1))-jzd2(jOsX,1))/F;
    % assignin('base','da',da);
    
    jak_moc = 10;
    ze = robot2(3):k*jak_moc:stred(3); % od pozice z koncového bodu do počátku robata
    % assignin('base','ze',ze);
    sz = numel(ze);
    se = numel(t);
    
    % vypocet smernice y pro rozsireni poloosy b
    db1 = (-l_efektor*sind(60)+robot2(2))-jzd2(2,2);
    db2 = (l_efektor*sind(60)+robot2(2))-jzd2(3,2);
    if abs(db1)>abs(db2)
        db = db1/F;
        jOsY = 2;
    else
        db = -db2/F;
        jOsY = 3;
    end
    
    % Vykresleni primky urceni smernice pro zmenu poloosy b
    % plot3([400,400],[-(-1)^jOsY*l_efektor*sind(60)+robot2(2),jzd2(jOsY,2)],[robot2(3),jzd2(jOsY,3)],'LineWidth',5)
    
    % Vykresleni elips v menicim se z
    for c = 1:sz-1
        zp = ones(1,se)*ze(c);
        elipsa = [elipsa_S(1) + (a+da*jak_moc*c)*cos(t); elipsa_S(2) + (b+db*jak_moc*c)*sin(t);];
        plot3(elipsa(1,:)+(c*jak_moc*i),elipsa(2,:)+(c*jak_moc*j),zp, 'LineWidth',0.5,'Color','r');
    end
    
    % spojnice teziste jezdcu s koncovym bodem
    plot3([robot2(1),xT],[robot2(2),yT],[robot2(3),zT],'g');
    


    % Vypocet korektni polohy robotu1
    % z = robot1(3)
    dz = abs(robot2(3) - robot1(3));
    z = ones(1,se)*robot1(3);
    a_v = a+da*dz;
    b_v = b+db*dz;
    elipsa = [elipsa_S(1)+(dz*i) + (a_v)*cos(t); elipsa_S(2)+(dz*j) + (b_v)*sin(t);];
    plot3(elipsa(1,:),elipsa(2,:),z, 'LineWidth',2,'Color','g');

    if ((robot1(1)-elipsa_S(1)+(dz*i))^2/a_v^2 + (robot1(2)-elipsa_S(2)+(dz*j))^2/b_v^2) > 1
        e = 1;
        barva = [0,0.7,0];
    else
        e = 0;
        barva = 'r';
    end
    title("Pozice robotu " + string(logical(e)),Color=barva)
    plot3([robot1(1),robot2(1)],[robot1(2),robot2(2)],[robot1(3),robot2(3)],'o','Color',barva,'LineWidth',2)
end