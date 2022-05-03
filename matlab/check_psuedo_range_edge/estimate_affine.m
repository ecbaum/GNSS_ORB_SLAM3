function [A, t] = estimate_affine(pts, pts_tilde)

M = [];
v = [];
for i = 1:length(pts)
    x = pts(1,i);
    y = pts(2,i);
    
    x_t = pts_tilde(1,i);
    y_t = pts_tilde(2,i);
    
    M_pt = [x y 0 0 1 0; 0 0 x y 0 1];
    v_pt = [x_t; y_t];
    
    M = [M; M_pt];
    v = [v; v_pt];
end

theta = M\v;

A = [theta(1) theta(2); theta(3) theta(4)];
t = [theta(5); theta(6)];