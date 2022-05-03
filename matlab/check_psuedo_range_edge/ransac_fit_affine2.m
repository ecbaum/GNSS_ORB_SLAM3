function tf = ransac_fit_affine2(pts, pts_tilde, tau, n)
    m = size(pts,2);
    %n = 5;                   % Nr of points used for model fitting, n >= 3
    eta = 0.01;              % Probabilty of faliure
    epsilon = 0.01;          % Initial estimated inlier ration
    N_max = 100000; % Initial N_max
    N = 0;
    tf = [];
    while N < N_max
        N = N+1;    
        % Fits model for n random points
%         index = randperm(m);
%         test_points = index(1:n);
        test_points = randperm(m,n);
        %[A,t] = estimate_affine(pts(:,test_points),pts_tilde(:,test_points));
        [tf,~]= absolute_ori(pts(:,test_points),pts_tilde(:,test_points),ones(1,length(test_points)));
        % Finds number of points within tau
        residual = residual_lgths(tf, pts, pts_tilde);
        is_inlier = [];
        is_inlier = find(residual<tau);
        inlier_ratio = length(is_inlier)/m;
        
        % Evaluates model based on current inlier ration
        if inlier_ratio > epsilon
            % Updates best solution
            %[A_best,t_best] = estimate_affine(pts(:,is_inlier),pts_tilde(:,is_inlier));
            [tf,~]=absolute_ori(pts(:,is_inlier),pts_tilde(:,is_inlier),ones(1,length(is_inlier)));
            % Updates epsilon and N_max
            epsilon = inlier_ratio;
            N_max = ceil(log(eta)./log(1-epsilon.^(n)));
            
        end
    end
end