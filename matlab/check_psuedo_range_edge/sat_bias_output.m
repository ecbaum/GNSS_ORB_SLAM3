clear all; clc;


msg = readtable('GNSS_Messages.txt');
msg.Var8(:) = NaN;
times = msg{:,2};
t0 = times(1);
t1 = times(end);

%%
tb = readtable('gfz20684.txt');

idx_st = 18000;

sat_bias = cell(1,32);
disp('reading all bias data')
for i = 1:2500%size(tb,1)
    splitcells = regexp(tb{idx_st+i,1}, '\s+', 'split');
    id_str = splitcells{1}{2};
    id_int = str2num(id_str(2:3));
    identifier = id_str(1);

    if identifier == 'G'
        yr = str2num(splitcells{1}{3});
        m = str2num(splitcells{1}{4});
        d = str2num(splitcells{1}{5});
    
        date = [num2str(yr,'%02d'), '-', num2str(m,'%02d'), '-', num2str(d,'%02d')];
    
    
        h = str2num(splitcells{1}{6});
        m = str2num(splitcells{1}{7});
        s = floor(str2num(splitcells{1}{8}));
    
        
        time = [num2str(h,'%02d'), ':', num2str(m,'%02d'), ':', num2str(s,'%02d')];
    
        dt = [date, ' ', time];
        unix_time = posixtime(datetime(dt));
        disp(i)
        if t0 <= unix_time && unix_time <= t1 + 100
            disp("ok")
            bias = str2num(splitcells{1}{10});
            sat_biases_ = {unix_time, id_str, bias};
            sat_bias{id_int} = [sat_bias{id_int}, {sat_biases_}];
        end
    end


end
disp('done')
%%

sat_bias_ranges = cell(1,32);

for i = 1:32
    sat_bias_i = sat_bias{i};
    t = [];
    b = [];
    for j = 1:size(sat_bias_i,2)
        t_ = sat_bias_i{j}{1};
        b_ = sat_bias_i{j}{3};

        t = [t, t_];
        b = [b, b_,];
    end

    sat_bias_ranges{i} = {t,b};
end
%%
for i = 1:size(msg,1)
    t_epoch = msg{i,2};
    id = msg{i,3};
    
    t_ = sat_bias_ranges{id}{1};
    b_ = sat_bias_ranges{id}{2};
    
    bias_interp = interp1(t_,b_,t_epoch);

    msg{i,end} = bias_interp;

    
    
end

