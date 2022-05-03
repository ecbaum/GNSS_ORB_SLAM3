clear all; clc, close all
addpath("res_G")

SPP = readtable('SPPGPS.csv');
msg = readtable('GNSS_Messages.txt');

load_sat_bias

c = 299792458;

sat_pos = {};

for i = 1:32
    try
        filename = ['res_G/res_G', num2str(i,'%02d'),'.csv'];
        sat_pos{i} = readtable(filename);
    catch
        sat_pos{i} = {-1};
    end
end

%%
coord = SPP{1,2:end};
P_earth = GeodeticToECEF(coord)';

pr_pos_all = {};

for i = 1:29

    sat_id_str = sat_bias{i,1};
    id = str2num(sat_id_str(2:end));
      
    msg_sat = msg(find(msg{:,3} == id),:);
    
    pr_pos = {};
    
    sat_pos_id = sat_pos{id};
    
    
    for j = 1:size(msg_sat)
        
        sat_time = msg_sat{j,2};
        pr = msg_sat{j,4};
    
        sat_pos_km = sat_pos_id{find(sat_pos_id{:,1} == sat_time),2:end}'*1000;
        
        pr_pos{j,1} = pr;
        pr_pos{j,2} = sat_pos_km;
        pr_pos{j,3} = sat_time;
    end
    
    
    pr_pos_all{i} = {id, pr_pos, };

end

%%
sat_bias_id = [];
for j = 1:size(sat_bias,1)
    disp(str2num(sat_bias{j,1}(2:end)))
    
end
%%

err_all = {};
t_all = {};
for i = 1:size(pr_pos_all,2)
    if size(pr_pos_all{i}{2},1) > 0
        id = pr_pos_all{i}{1};
        sat_bias_f = [];
        for k = 1:size(sat_bias,1)
            if id == str2num(sat_bias{k,1}(2:end))
                sat_bias_f = sat_bias{k,2};
            end
        end
        pr_pos = pr_pos_all{i}{2};

        err = [];
        t_vec = [];
        for j = 1:size(pr_pos,1)
            pr_j = pr_pos{j,1};
            sat_pos_j = pr_pos{j,2};
            t_j = pr_pos{j,3};

            e = norm(sat_pos_j - P_earth) -c*sat_bias_f - pr_j;
            err = [err, e];
            t_vec = [t_vec, t_j];
        end
        t_all = [t_all, t_vec];
        err_all = [err_all, err];
    end
    

end

%%
close all
figure
hold on
t0 = t_all{1}(1);
y0 = err_all{1}(1);
for i = 1:size(err_all,2)
    scatter(t_all{i}-t0,err_all{i}-y0,'.')
end
