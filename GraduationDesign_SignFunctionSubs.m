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
   ͬʱ������x��y�ֱ��滻Ϊ1��z��subs(S,{x,y},{1,z})
%}