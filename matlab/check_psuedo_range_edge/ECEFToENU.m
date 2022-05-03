function v = ECEFToENU(ECEF, p_WE_WG, R_WE_WG)

v = transpose(R_WE_WG) * (ECEF - p_WE_WG)'; 


