tb = readtable('gfz20684.txt');

idx_st = 311;

sat_bias = cell(1,32);


for i = 1:200
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
        
        bias = str2num(splitcells{1}{10});
        sat_biases_ = {unix_time, id_str, bias};
        sat_bias{id_int} = [sat_bias{id_int}, {sat_biases_}];

    end


end