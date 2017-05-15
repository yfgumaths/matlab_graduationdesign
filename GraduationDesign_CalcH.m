function H=GraduationDesign_CalcH(P,n)
   ans = 0;
   for i = 1:n
    for j = 1:n
       ans = ans - P(i,j)*log(P(i,j));
    end
   end
   H = ans;
end