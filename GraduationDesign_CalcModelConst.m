function [G11,G12,G21,G22,Alpha,Beta,Gamma,Sita,Alpha2,Beta2,Gamma2,Sita2] = GraduationDesign_CalcModelConst()
    clc
    t = 5;
    delta_t = t - 1;
    labour = [5.343, 5.802, 6.186, 6.428, 6.828];
    algriculture = [61.760, 58.959, 55.445, 52.587, 49.587];%农业劳动力百分比
    industry     = [28.239, 27.908, 27.259, 26.855, 26.455];%工业劳动力百分比
    business     = [10.001, 13.134, 17.296, 20.559, 23.958];%商业劳动力百分比
    q1           = [63.153, 62.007, 61.030, 59.819, 58.719];%农村劳动力百分比
    q2           = [36.847, 37.993, 38.970, 40.181, 41.281];%城市劳动力百分比
    for i = 1:t
        algriculture(i) = algriculture(i)/100*labour(i);
        industry(i) = industry(i)/100*labour(i);
        business(i) = business(i)/100*labour(i);
        q1(i) = q1(i)/100*labour(i);
        q2(i) = q2(i)/100*labour(i);
    end
    
    
    algri_delta = zeros(delta_t,1);
    indus_delta = zeros(delta_t,1);
    busin_delta = zeros(delta_t,1);
    q1_delta = zeros(delta_t,1);
    q2_delta = zeros(delta_t,1);
    for i = 1:delta_t
        algri_delta(i) = algriculture(i+1) - algriculture(i);
        indus_delta(i) = industry(i+1) - industry(i);
        busin_delta(i) = business(i+1) - business(i);
        q1_delta(i) = q1(i+1) - q1(i);
        q2_delta(i) = q2(i+1) - q2(i);
    end
    
    X = zeros(t,2);
    for i = 1:t
        X(i,1) = algriculture(i) + industry(i);
        X(i,2) = business(i);
    end
    y = q1'
    B = regress(y,X);
    
    y2 = q2'
    B2 = regress(y2,X);

    
    XX = zeros(delta_t,2);
    for i = 1:delta_t
        XX(i,1) = -1*q1(i);
        XX(i,2) = -1*q1(i)^3;
        %XX(i,3) = -1*q2(i);
        %XX(i,4) = -1*q2(i)^3;
        %XX(i,3) = -1*q1(i)^3;
    end

    yy = q1_delta
    XX
    C = regress(yy,XX);
    
    XX2 = zeros(delta_t,2);
    for i = 1:delta_t
        XX2(i,1) = -1*q2(i);
        XX2(i,2) = -1*q2(i)^3;
        %XX2(i,3) = -1*q1(i);
        %XX2(i,4) = -1*q1(i)^3;
        %XX2(i,3) = -1*q2(i)^3;
    end
    
    yy2 = q2_delta
    XX2
    C2 = regress(yy2,XX2);
    
    
    G11 = B(1)
    G12 = B(2)
    G21 = B2(1)
    G22 = B2(2)
    
    Alpha = C(1)
    Beta = C(2)
    Gamma = 0
    Sita = 0
    Alpha2 = C2(1)
    Beta2 = C2(2)
    Gamma2 = 0
    Sita2 = 0
    %plot_x = zeros(100,1);
    %plot_y = zeros(100,1);
    %for i = 1:100
    %    plot_x(i) = -10 + 0.2*i;
    %    plot_y(i) = -Alpha2*plot_x(i) -Beta2*plot_x(i)^3;
    %end
    %plot(plot_x,plot_y);
    
end