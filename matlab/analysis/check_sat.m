clear all; clc, close all

%SPP = readtable('SPPGPS.csv');
msg = readtable('2019_HK_GNSS_Message.csv');
satpos1 = readtable('res_G19.csv');
satpos3 = readtable('res_G06.csv');

c = 299792458;
tsv1 = -0.325386686172e-03;
tsv3 = 0.219422443149e-03;


%rec_b = -183202e-09;
coord = [22.301153566674070, 114.1790009718058, 6.428215120919049];

P_earth = GeodeticToECEF(coord)';
%%

msg_sat1 = msg(find(msg{:,3} == 19),:);



errors1 = [];

for idx = 1:size(msg_sat1)
    
    sat_time = msg_sat1{idx,2};
    
    sat_pos_km = satpos1{find(satpos1{:,1} == sat_time),2:end}';
    sat_pos_m = sat_pos_km*1000;
    pr = msg_sat1{idx,4};


    d = norm(sat_pos_m-P_earth) -c*tsv1 - pr;

    errors1 = [errors1, d];

end
t1 = msg_sat1{:,2} - min(msg_sat1{:,2});

%%
msg_sat3 = msg(find(msg{:,3} == 6),:);

%coord = SPP{200,2:end};
%P_earth = GeodeticToECEF(coord)';

errors3 = [];
prr = [];
sss = [];
for idx = 1:size(msg_sat3)
    
    sat_time = msg_sat3{idx,2};
    
    sat_pos_km = satpos3{find(satpos3{:,1} == sat_time),2:end}';
    sat_pos_m = sat_pos_km*1000;
    pr = msg_sat3{idx,4};


    d = norm(sat_pos_m - P_earth) - c*tsv3 - pr;
    prr = [prr, pr];
    sss = [sss, sat_pos_km];
    errors3 = [errors3, d];

end
t3 = msg_sat3{:,2} - min(msg_sat3{:,2});

%%
figure
scatter(t1,errors1)
hold on
scatter(t3,errors3)
err = errors3(find(abs(errors3)<100000));
%%

