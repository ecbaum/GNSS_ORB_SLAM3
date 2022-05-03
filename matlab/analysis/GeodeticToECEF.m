function v = GeodeticToECEF(geodeticCoordinates)


a = 6378137.0000;
b = 6356752.3142; 
e2 = 1 - b^2 / a^2; 


phi    = geodeticCoordinates(1)*pi/180;
lambda = geodeticCoordinates(2)*pi/180;
h      = geodeticCoordinates(3);

%N_phi = a/sqrt(1 - e2*(sin(phi))^2);
N_phi = a^2/sqrt(a^2*cos(phi)^2 + b^2*sin(phi)^2);

x = (N_phi + h) * cos(phi) * cos(lambda);
y = (N_phi + h) * cos(phi) * sin(lambda);
z = ((b^2 / a^2) * N_phi + h) * sin(phi);

v = [x,y,z];
