function GraduationDesign_SecondStep()
clc
    P = [0.1282,0.2140,0.2405;
    0.0674,0.0911,0.1179;
    0.0355,0.0552,0.0503];
    ans = 0;
    n = 3;
    d = [0,3,4;
     3,0,5;
     4,5,0;];
    for i = 1:n
        for j = 1:n
           ans = ans + P(i,j);
        end
    end
    ans
    M = 3000;
    P_M = P*M
    deltad = 0;
    for i = 1:n 
        for j = 1:n
            deltad = deltad + d(i,j)*P(i,j);
        end
    end
    deltad
    
    shang = GraduationDesign_CalcH(P,n)
end