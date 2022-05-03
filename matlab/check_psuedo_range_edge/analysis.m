close all; clear all; clc

SPP = readtable('SPPGPS.csv');
SPP_ECEF = SPP;

for i=1:size(SPP_ECEF)
    SPP_ECEF{i,2:end} = GeodeticToECEF(SPP_ECEF{i,2:end});
end


ref = setRef(SPP{1,2:end});


SPP_ENU = SPP_ECEF;
for i=1:size(SPP_ENU)
    SPP_ENU{i,2:end} = ECEFToENU(SPP_ENU{i,2:end}, ref{1}, ref{2})';
end
%%

subplot(1,3,1)
plot(SPP{:,2},SPP{:,3})
subplot(1,3,2)
plot(SPP_ECEF{:,2},SPP_ECEF{:,3})
subplot(1,3,3)
plot(SPP_ENU{:,2},SPP_ENU{:,3})



%%


KFs = readtable('f_dataset-MH01_monoi.txt');
KFs{:,1} = KFs{:,1}*1e-9;
%%
plot(KFs{:,2},KFs{:,3},'.')



%%
close all
figure
hold on
scatter(SPP_ENU{:,2},SPP_ENU{:,3},'x')
scatter(KFs{:,2},KFs{:,3},'x')
%%

KFsSync_ = [];

tolerance = 0.1;
KFs_times = KFs{:,1};
st = 1;
Ms = [];
for i=1:size(SPP_ENU)
    t_SPP = SPP_ENU{i,1};
    dist = abs(KFs_times-t_SPP);
    [m,idx] = min(dist);
    Ms = [Ms, m];
    KFsSync_ = [KFsSync_; [KFs{idx,2:end}, t_SPP, KFs_times(idx)]];
end
 
KFsSync_ =  array2table(KFsSync_);

%%
st = 10;
sp = 200;
tol = 4;
nbr_points = 4;

KFsSync = KFsSync_{st:sp,1:3};
SPP_ENU_Sync = SPP_ENU{st:sp,2:end};

M = SPP_ENU_Sync';
D = KFsSync';

tf_ransac = ransac_fit_affine2(M, D, tol, nbr_points);
tf_LQ = absolute_ori(M,D,ones(1,length(M)));

M_hom = [M;ones(1,length(M))];


clf

scatter3(D(1,:),D(2,:),D(3,:),'.')
hold on

M_TF_Ransac = tf_ransac*M_hom;
scatter3(M_TF_Ransac(1,:),M_TF_Ransac(2,:),M_TF_Ransac(3,:))
hold on
M_TF_LQ = tf_LQ*M_hom;
scatter3(M_TF_LQ(1,:),M_TF_LQ(2,:),M_TF_LQ(3,:),'x','r')
%%


msg = readtable('GNSS_Messages.txt');
satpos = readtable('res_G01.csv');

gframes = [];
tolerance = 0.3;
frame_times = KFs{:,1};
st = 1;
Ms = [];
for i=1:size(msg)
    t_pr = msg{i,2};
    dist = abs(KFs_times-t_pr);
    [m,idx] = min(dist);
    if m < tolerance && msg{idx,3} == 1
        Ms = [Ms, m];
        pos_idx = find(satpos{:,1} == t_pr);
        pos = satpos{pos_idx,2:end};
        gframes = [gframes; [KFs{idx,1:end},t_pr msg{i,4}, pos]];
    end
end
gframes =  array2table(gframes);
gframes.Properties.VariableNames = {'t_KF','x','y','z','q0','q1','q2','q3','t_pr', 'pr', 'satX','satY','satZ'};

%%

P_WE_WG = ref{1}';
R_WE_WG = ref{2};

gf = gframes{10,:};

P_WE_si_e = gf(11:13)';

P_WL_gme = gf(2:4)' ;

P_WG_WL = tf_ransac(1:3,4);
R_WG_WL = tf_ransac(1:3,1:3);

pr = gf(10);

%%


norm(P_WE_si_e*1000 - (R_WE_WG*R_WG_WL*P_WL_gme + R_WE_WG*P_WG_WL + P_WE_WG)) - pr


%%

pos_ecef = SPP_ECEF{1,2:end}';

pos_sat_ = P_WE_si_e*1000;
