function out = squareMotion(x,y,z,Alpha,Beta,Gamma)
size=50;
T = [cos(Alpha)*cos(Beta),  cos(Alpha)*sin(Beta)*sin(Gamma)-sin(Alpha)*cos(Gamma),  cos(Alpha)*sin(Beta)*cos(Gamma)+sin(Alpha)*sin(Gamma)  ,x;
     sin(Alpha)*cos(Beta),  sin(Alpha)*sin(Beta)*sin(Gamma)+cos(Alpha)*cos(Gamma),  sin(Alpha)*sin(Beta)*cos(Gamma)-cos(Alpha)*sin(Gamma)  ,y;
     -sin(Beta),           cos(Beta)*sin(Gamma)                               ,  cos(Beta)*cos(Gamma)                                      ,z;
       0                  ,  0                                                 ,  0                                                        ,1];%¹æ»®

X_dot=([0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]-0.5)*size;
Y_dot=([0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]-0.5)*size;
Z_dot=([0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]-0.5)*size;
for i=1:24
    A = T*[X_dot(i),Y_dot(i),Z_dot(i),1]';
    X_dot(i) = A(1);
    Y_dot(i) = A(2);
    Z_dot(i) = A(3);
end
for i=1:6
    h=patch(X_dot(:,i),Y_dot(:,i),Z_dot(:,i),'b');
    set(h,'edgecolor','k','facealpha',0.6);
end

h=gcf;

axis equal
axis([-150 150 -150 150 -150 150]);
grid on
view(-60,15);
out=1;
