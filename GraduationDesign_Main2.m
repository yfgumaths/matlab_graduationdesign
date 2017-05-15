function GraduationDesign_Main2()
    [g11,g12,g21,g22,alpha,beta,gamma,sita,alpha2,beta2,gamma2,sita2] = GraduationDesign_CalcModelConst();
    clc
    epsilon = 1e-6;
    t = 5;
    delta_t = t - 1;
    labour = [5.343, 5.802, 6.186, 6.428, 6.828];
    algriculture = [61.760, 58.959, 55.445, 52.587, 49.587];%ũҵ�Ͷ����ٷֱ�
    industry     = [28.239, 27.908, 27.259, 26.855, 26.455];%��ҵ�Ͷ����ٷֱ�
    business     = [10.001, 13.134, 17.296, 20.559, 23.958];%��ҵ�Ͷ����ٷֱ�
    q1           = [63.153, 62.007, 61.030, 59.819, 58.719];%ũ���Ͷ����ٷֱ�
    q2           = [36.847, 37.993, 38.970, 40.181, 41.281];%�����Ͷ����ٷֱ�
    for i = 1:t
        algriculture(i) = algriculture(i)/100*labour(i);
        industry(i) = industry(i)/100*labour(i);
        business(i) = business(i)/100*labour(i);
        q1(i) = q1(i)/100*labour(i);
        q2(i) = q2(i)/100*labour(i);
    end
    q1(:);
    q2(:);
    %algriculture(i) i ��ũҵ�Ͷ�������
    %industry(i) i �깤ҵ�Ͷ�������
    %business(i) i ����ҵ�Ͷ�������
    %q1(i) i ��ũ���Ͷ�������
    %q2(i) i ������Ͷ�������
    
    maxStep = 100;
    i = 0
    diedai_ctl1 = algriculture(1) + industry(1);
    diedai_ctl2 = business(1);
    diedai_qq1 = g11 * diedai_ctl1 + g12 * diedai_ctl2;
    diedai_qq2 = g21 * diedai_ctl1 + g12 * diedai_ctl2;
    nowShang = GraduationDesign_CalcModelShang(diedai_qq1,diedai_qq2);
    
    while(i < maxStep)
        perShang = nowShang;
        diedai_dq1 = -1*alpha*diedai_qq1 - beta*diedai_qq1^3 - gamma*diedai_qq2 - sita*diedai_qq2^3;
        diedai_dq2 = -1*alpha2*diedai_qq2 - beta2*diedai_qq2^3 - gamma2*diedai_qq1 - sita2*diedai_qq1^3;
        diedai_qq1 = diedai_qq1 + diedai_dq1 
        diedai_qq2 = diedai_qq2 + diedai_dq2
        diedai_Y = [diedai_qq1;diedai_qq2];
        diedai_X = [g11,g12;
                    g21,g22];
        diedai_Alpha = regress(diedai_Y,diedai_X)
        nowShang = GraduationDesign_CalcModelShang(diedai_qq1,diedai_qq2);
        nowShang
        if abs(nowShang - perShang) < epsilon 
            i
            break
        end
        i = i + 1
    end
    ansQ1 = diedai_qq1
    ansQ2 = diedai_qq2
    ansY = [ansQ1;ansQ2]
    ansX = [g11,g12;
            g21,g22]
    ansAlpha = regress(ansY,ansX)
    ansAlpha(1)+ansAlpha(2) - ansQ1 - ansQ2
    
end