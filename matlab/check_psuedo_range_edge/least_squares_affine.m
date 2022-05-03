function [A, t] = least_squares_affine(pts, pts_tilde)
[A, t] = estimate_affine(pts, pts_tilde);