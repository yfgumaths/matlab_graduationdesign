function ans = GraduationDesign_GetMinLamda(fai,v,G,n)
    syms lamda;
    mat = v - lamda*G;
    func = GraduationDesign_SignFunctionSubs(fai,mat,n);
    [lam0,minfunc]=fminbnd(matlabFunction(func),0,1);
    ans = lam0;
end


%{
clear;clc;formatcompact
syms x
f =3*x^4-16*x^3+30*x^2-24*x+8;
% f =x^4-4*x^3-6*x^2-16*x+4; %书上P99例题
x0 = 3; %设置初始点
i = 1;
while(i)
    x0 = x0-subs(diff(f,x),x0)/subs(diff(diff(f,x),x),x0);%牛顿法迭代
    if abs(subs(diff(f,x),x0))<1e-4 %迭代停止的条件
        i = 0;
    end
end
disp(sprintf('用牛顿法求得的近似解为%9.15f',double(x0))) %打印结果
%}