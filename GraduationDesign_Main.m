function GraduationDesign_Main()
    clc
    %define 
    syms z fai test h trans G dfaiz curfaiadd;
    n =3;%总的地区数
    epsilon = 1e-6;
    maxiter = 10000;
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

    O = [1748,829,423];%一定时期内迁出人口数
    D = [693,1081,1226];%一定时期内各地迁入人口数
    C = exp(-1);
        d = [0,3,4;
             3,0,5;
             4,5,0;];
    aveO = O/M
    aveD = D/M
    
    
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
    
    % get h expression
    %{
    h = 0;
    for i = 1:n 
        for j = 1:n
            trans = C*x(i)*y(j)*(z^d(i,j))*d(i,j);
            h = h + trans;
        end
        h = h - aved;
    end
    %}
    
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
    
    %fai = fai + h*h;
    %set init
    
    k = 1;
    v = zeros(maxiter,2*n+1);
    G = zeros(maxiter,2*n+1);
    for i = 1:2*n+1 
        v(1,i) = 0.1;
    end

    % main iterator
    while (k <= maxiter)
        Gnow = zeros(1,2*n+1);
        vnow = v(k,:);
        fprintf('fai  ');
        fai;
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
        calcError = norm(Gnow,2)
        if calcError < epsilon 
            break
        else 
            lamda = GraduationDesign_GetMinLamda(fai,vnow,Gnow,n);
            v(k+1,:) = vnow - lamda*Gnow;
        end
        k = k+1;
        
    end
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
    
    
    %calc ans
end


