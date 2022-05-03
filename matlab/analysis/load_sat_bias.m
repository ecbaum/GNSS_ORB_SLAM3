tb = readtable('gfz20510.txt');

idx_st = 311;

sat_bias = {};

for i = 1:42
    splitcells = regexp(tb{idx_st+i,1}, '\s+', 'split');
    id = splitcells{1}{2};
    identifier = id(1);

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
    sat_bias(i,1:2) = {id, bias};
end