function ans = GraduationDesign_SignFunctionSubs(f,v,n)
    syms z;
    for i=1:n
        x(i)=sym(['x',num2str(i)]);
        y(i)=sym(['y',num2str(i)]);
    end
    for  i = 1:n
        f = subs(f,x(i),v(i));
    end
    for i = 1:n
        f = subs(f,y(i),v(i+n));
    end
    f = subs(f,z,v(2*n+1));
    ans = f;
end


%{
   同时将变量x和y分别替换为1和z：subs(S,{x,y},{1,z})
%}