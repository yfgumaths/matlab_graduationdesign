function GraduationDesign_Main()
    clc
    %define 
    syms z fai test h trans G dfaiz curfaiadd;
    n =7;%总的地区数
    epsilon = 1e-4;
    maxiter = 900;
    for i=1:n
        x(i)=sym(['x',num2str(i)]);
        y(i)=sym(['y',num2str(i)]);
        f(i)=sym(['f',num2str(i)]);
        g(i)=sym(['g',num2str(i)]);
        ff(i)=sym(['ff',num2str(i)]);
        dfaix(i)=sym(['dfaix',num2str(i)]);
        dfaiy(i)=sym(['dfaiy',num2str(i)]);
    end
    M = 3000;%总的迁移人口数

    O = [246, 1147, 1346, 163, 86, 8, 4];%一定时期内迁出人口数
    D = [ 20, 6,11,357, 385,412, 1809];%一定时期内各地迁入人口数
    C = exp(-1);
    d = [0, 728, 83, 702, 58, 330, 912;
        728, 0, 70, 43, 663, 59, 997;
        83, 70, 0, 886, 781, 836, 631;
        702, 43, 886, 0, 580, 601, 797;
        58, 663, 781, 580, 0, 958, 534;
        330, 59, 836, 601, 958, 0, 545;
        912, 997, 631, 797, 534, 545, 0;];
    d = d/1000;
    aveO = O/M
    aveD = D/M
    aved = 0.5
    
    
    % get f expression
    for i = 1:n
        f(i) = 0;
        for j = 1:n
            ff(j) = C*x(i)*y(j)*(z^d(i,j));
            f(i) = f(i) + ff(j);
        end
        f(i) = f(i) - aveO(i);
    end
    
    % get g expression
    for j = 1:n
        g(j) = 0;
        for i = 1:n
            ff(j) = C*y(j)*x(i)*(z^d(i,j));
            g(j) = g(j) + ff(j);
        end
        g(j) = g(j) - aveD(j);
    end
    
    %get h expression
    %%{
    h = 0;
    for i = 1:n 
        for j = 1:n
            trans = C*x(i)*y(j)*(z^d(i,j))*d(i,j);
            h = h + trans;
        end
    end
    h = h - aved;
    %%}
    
    % get fai expression
    fai = 0;
    for i = 1:n
        dfaix(i) = 0;
        dfaiy(i) = 0;
    end
    
    dfaiz = 0;
    for i = 1:n
        curfaiadd = f(i)*f(i) + g(i)*g(i);
        fai = fai + curfaiadd;
        for j = 1:n
            dfaix(j) = dfaix(j) + diff(curfaiadd,x(j));
            dfaiy(j) = dfaiy(j) + diff(curfaiadd,y(j));
        end
        dfaiz = dfaiz + diff(curfaiadd,z);
    end
    
    %%{
    fai = fai + h*h;
    for j = 1:n
        dfaix(j) = dfaix(j) + diff(h*h,x(j));
        dfaiy(j) = dfaiy(j) + diff(h*h,y(j));
    end
    dfaiz = dfaiz + diff(h*h,z);
    %%}
    
    %set init
    
    k = 1;
    v = zeros(maxiter,2*n+1);
    G = zeros(maxiter,2*n+1);
    for i = 1:2*n+1 
        v(1,i) = 0.2;
    end
    err = zeros(1,maxiter);
    % main iterator
    while (k <= maxiter)
        Gnow = zeros(1,2*n+1);
        vnow = v(k,:);
        for i = 1:n
            test = dfaix(i);
            testans = GraduationDesign_SignFunctionSubs(test,vnow,n);
            Gnow(i) = testans;
        end
        for i = 1:n
            test = dfaiy(i);
            testans = GraduationDesign_SignFunctionSubs(test,vnow,n);
            Gnow(n+i) = testans;
        end
        test = dfaiz;
        Gnow(2*n+1) = GraduationDesign_SignFunctionSubs(test,vnow,n);
        G(k,:) = Gnow;
        k
        calcError = norm(Gnow,2)
        err(k) = calcError;
        if calcError < epsilon 
            break
        else 
            lamda = GraduationDesign_GetMinLamda(fai,vnow,Gnow,n);
            v(k+1,:) = vnow - lamda*Gnow;
            del_P_x = zeros(n,1);
            del_p = zeros(n);
            del_P_y = zeros(n,1);
            del_P_z = v(k,2*n+1);
            for i = 1:n
               del_P_x(i) = v(k,i);
               del_P_y(i) = v(k,n+i);
            end
            for i = 1:n
                for j = 1:n
                    del_p(i,j) = C*del_P_x(i)*del_P_y(j)*(del_P_z^d(i,j));
                end
            end
            del_p
            del_P_M = del_p*M;
        end
        k = k+1;
    end
    k
    vans = zeros(2*n+1,1);
    for i = 1:2*n+1
        vans(i) = v(k,i);
    end
    vans
    %get p 
    p = zeros(n);
    P_x = zeros(n,1);
    P_y = zeros(n,1);
    P_z = vans(2*n+1);
    for i = 1:n
        P_x(i) = vans(i);
        P_y(i) = vans(n+i);
    end
    for i = 1:n
        for j = 1:n
            p(i,j) = C*P_x(i)*P_y(j)*(P_z^d(i,j));
        end
    end
    
    
    
    ans = 0;
    for i = 1:n
        for j = 1:n
           ans = ans + p(i,j);
        end
    end
    ans
    M = 3000;
    P_M = p*M
    deltad = 0;
    for i = 1:n 
        for j = 1:n
            deltad = deltad + d(i,j)*p(i,j);
        end
    end
    deltad
    
    shang = GraduationDesign_CalcH(p,n)
    if k > maxiter
        k = maxiter;
    end
    err_X = err(1:k)
    err_Y = 1:k
    plot(err_Y,err_X);
    xlabel('迭代次数');
    ylabel('梯度范数');
    %calc ans
end


