close all; clear all; clc

x1=1;x2=2;x3=3;

y1=1;y2=2;

triangle_x=[x1,x2,x3,x1];

triangle_y=[y1,y2,y1,y1];

fill(triangle_x,triangle_y,'b');
hold on;
axis([0,4,0,3]);axis equal;

a =  [
    1  0  0  x1;
    0  1  0  y1;
    0  0  1  0;
    0  0  0  1 ];
b =  [
    1  0  0  x2;
    0  1  0  y2;
    0  0  1  0;
    0  0  0  1 ];
c =  [
    1  0  0  x3;
    0  1  0  y1;
    0  0  1  0;
    0  0  0  1 ];


%平移
trans = [
    1  0  0  2;
    0  1  0  2;
    0  0  1  0;
    0  0  0  1 ];

% Rot = [
%     1  0  0  0;
%     0  1  0  0;
%     0  0  1  0;
%     0  0  0  1 ];
%x旋转
% Rot = [
%     1  0         0          0;
%     0  cosd(50)  -sind(50)  0;
%     0  sind(50)  cosd(50)   0;
%     0  0        0           1 ];
% 
%y旋转
% Rot = [
%     cosd(50)  0   sind(50)   0;
%     0         1         0    0;
%     -sind(50) 0   cosd(50)   0;
%     0         0         0    1 ];



a = trans*a;
b = trans*b;
c = trans*c;


x1=a(1,4);x2=b(1,4);x3=c(1,4);

y1=a(2,4);y2=b(2,4);

triangle_x=[x1,x2,x3,x1];

triangle_y=[y1,y2,y1,y1];

fill(triangle_x,triangle_y,'b');

%z旋转
Rot = [
    cosd(-5)  -sind(-5)   0          0;
    sind(-5)   cosd(-5)   0          0;
    0          0          1          0;
    0          0          0          1 ];

a = Rot*a;
b = Rot*b;
c = Rot*c;

x1=a(1,4);x2=b(1,4);x3=c(1,4);

y1=a(2,4);y2=b(2,4);

triangle_x=[x1,x2,x3,x1];

triangle_y=[y1,y2,y1,y1];

fill(triangle_x,triangle_y,'r');
