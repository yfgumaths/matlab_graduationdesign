function ans = GraduationDesign_CalcModelShang(q1, q2)
    totalpeople = q1 + q2;
    q1_percent = q1/totalpeople;
    q2_percent = q2/totalpeople;
    ans = 1 - q2_percent + q1_percent;
end