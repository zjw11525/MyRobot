 function [Tf1,V,A,J,T] = SCurvePara(Tf, v, a)
 %%
 T = zeros(1,7);
for i=1:1000
    J = (a^2 * v) / (Tf*v*a - v^2 - a);
    T(1) = a / J;
    T(2) = v / a - a / J; % t2 = v / a - t1;
    T(3) = T(1);
    T(4) = Tf - 2 * a / J - 2 * v / a;    % t4 = Tf - 4*t1 - 2*t2;
    T(5) = T(3);
    T(6) = T(2);
    T(7) = T(1);
    if T(2) < -1e-6
        a = sqrt(v*J);
        display('t2<0');
    elseif T(4) < -1e-6
        v = Tf*a/2 - a*a/J;
        display('t4<0');
    elseif J < -1e-6
        Tf = (v^2 + a) / (v*a) + 1e-1;
        display('J<0');
    else
        break;
    end
end

 A = a;
 V = v;
 Tf1 = Tf;
 end
