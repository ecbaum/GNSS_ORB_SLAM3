function [A,t] = ransac_fit_affine(pts, pts_tilde, threshold)
K_max = 1000;

A = [];
t = [];
current_lowest_num_outliers = inf;

for k = 1:K_max
    idx = randperm(length(pts),3);
    selected_pts = pts(:,idx);
    selected_pts_tilde = pts_tilde(:,idx);
    [A_cand,t_cand] = estimate_affine(selected_pts, selected_pts_tilde);
    
    %res_lgths = residual_lgths(A_cand, t_cand, pts, pts_tilde);
    
    %num_outliers = length(find(res_lgths>threshold == 1));
    num_outliers = 0;
    for i = 1:length(pts)
        if norm(pts_tilde(:,i) - (A_cand*pts(:,i) + t_cand)) > threshold
            num_outliers = num_outliers + 1;
        end
    end
        
    if num_outliers < current_lowest_num_outliers
        current_lowest_num_outliers = num_outliers;
        A = A_cand;
        t = t_cand;
    end
end