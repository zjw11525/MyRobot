 function out = dh( alpha,a,d,theta )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
out=[cos(theta) -sin(theta) 0 a
    sin(theta)*cos(alpha) cos(theta)*cos(alpha) -sin(alpha) -sin(alpha)*d
    sin(theta)*sin(alpha) cos(theta)*sin(alpha) cos(alpha) cos(alpha)*d
    0 0 0 1];
end

