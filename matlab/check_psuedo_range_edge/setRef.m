function v = setRef(SPP)


p_WE_WG = GeodeticToECEF(SPP);

phi    = deg2rad(SPP(1));
lambda = deg2rad(SPP(2));

R11 = -sin(lambda);          R12 =  cos(lambda);          R13 = 0;
R21 = -sin(phi)*cos(lambda); R22 = -sin(phi)*sin(lambda); R23 = cos(phi);
R31 = -cos(phi)*cos(lambda); R32 =  cos(phi)*sin(lambda); R33 = sin(phi);

R_WG_WE(1,1) = R11;
R_WG_WE(1,2) = R12;
R_WG_WE(1,3) = R13;
R_WG_WE(2,1) = R21;
R_WG_WE(2,2) = R22;
R_WG_WE(2,3) = R23;
R_WG_WE(3,1) = R31;
R_WG_WE(3,2) = R32;
R_WG_WE(3,3) = R33;

R_WE_WG = transpose(R_WG_WE);



v = {p_WE_WG, R_WE_WG};