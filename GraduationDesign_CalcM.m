function M = GraduationDesign_CalcM(A,O,B,D,d,n)
    M = zeros(n,n);
    for i = 1:n
        for j = 1:n
           M(i,j) = A(i)*O(i)*B(j)*D(j)*exp(-1.0*beta*d(i,j)); 
        end
    end
end