function y = interpolation(x0,x1,tf,t1)

v0=0;
v1=0;
a0=0;
a1=0;

b0 = x0;
b1 = v0;
b2 = a0/2;
b3 = (20.0*x1 - 20.0*x0 - (8.0*v1+12.0*v0)*tf - (3.0*a0-a1)*tf*tf)/(2.0*tf*tf*tf);
b4 = (30.0*x0 - 30.0*x1 + (14.0*v1 + 16.0*v0)*tf + (3.0*a0-2.0*a1)*tf*tf)/(2.0*tf*tf*tf*tf);
b5 = (12.0*x1 - 12.0*x0 - (6.0*v1+6.0*v0)*tf - (a0-a1)*tf*tf)/(2.0*tf*tf*tf*tf*tf);

t=t1;
y1 = b0 + b1*t + b2*t*t + b3*t*t*t + b4*t*t*t*t + b5*t*t*t*t*t;
y2 = b1 + 2*b2*t + 3*b3*t*t + 4*b4*t*t*t + 5*b5*t*t*t*t;
y3 = 2*b2 + 6*b3*t + 12*b4*t*t + 20*b5*t*t*t;
y=[y1 y2 y3];

end
