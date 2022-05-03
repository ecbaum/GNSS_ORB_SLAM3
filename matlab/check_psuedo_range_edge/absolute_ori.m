function [tf,s]=absolute_ori(x,y,w)
% This function finds the rigid body transformation between
% two point sets using least squre fitting and SVD
%Input source point set 3xN--->x
%Input target point set 3xN--->y
%input weights 1xn--->w
%Output T=[R,t;0,1], scale s;


x0=[sum(x(1,:).*w)/sum(w);sum(x(2,:).*w)/sum(w);sum(x(3,:).*w)/sum(w)];
y0=[sum(y(1,:).*w)/sum(w);sum(y(2,:).*w)/sum(w);sum(y(3,:).*w)/sum(w)];
dy=(y-y0);
dx=(x-x0);
H=zeros(3);

num=0;
den=0;
for i=1:length(w)
    H=H+(dx(:,i)*dy(:,i)')*w(1,i);
    
    num=dy(:,i)'*dy(:,i)*w(1,i);
    den=dx(:,i)'*dx(:,i)*w(1,i);
end

s=sqrt(num/den);

[U,D,V] = svd(H);

R=V*U';
T=y0-R*x0;

tf=eye(4);
tf(1:3,1:3)=R;
tf(1:3,4)=T;


end