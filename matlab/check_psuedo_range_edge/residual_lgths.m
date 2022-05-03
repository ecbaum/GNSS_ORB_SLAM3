function residual_lgths = residual_lgths(tf, pts, pts_tilde)


M_hom = [pts;ones(1,length(pts))];

M_TF = tf*M_hom;

res = pts_tilde - M_TF(1:3,:);

residual_lgths = sum(res.^2,1);