 function s = SCurveScaling(t,V,A,J,T,Tf)
%%
%  if A <= V*V
%      display('输入有误');
%      s = 0;
%      return;
%  else
%      if A <= 2*V*V
%          if (Tf > 2/V) || (Tf <= V/A + 1/V)    %% Tf <= V/A + 1/V  时 J<=0
%             display('输入有误');
%             s = 0;
%             return;
%          end
%      else
%          if (Tf > 2*V / A + 1/V) || (Tf <= V/A + 1/V)
%             display('输入有误');
%             s = 0;
%             return;
%          end         
%      end
%  end
% 
% J = (A^2 * V) / (Tf*V*A - V^2 - A);
% T(1) = A / J;
% T(2) = V / A - A / J; % T(2) = V / A - T(1);
% T(3) = T(1);
% T(4) = Tf - 2 * A / J - 2 * V / A;    % T(4) = Tf - 4*T(1) - 2*T(2);
% T(5) = T(3);
% T(6) = T(2);
% T(7) = T(1);
%%
if t >= 0 && t <= T(1)
    s = 1/6 * J * t^3;
elseif t > T(1) && t <= T(1)+T(2)
    dt = t - T(1);
    s = 1/2 * A * dt^2 + A^2/(2*J) * dt...
        + A^3/(6*J^2);
elseif t > T(1)+T(2) && t <= T(1)+T(2)+T(3)
     dt = t - T(1) - T(2);
     s = -1/6*J*dt^3 + 1/2*A*dt^2 + (A*T(2) + A^2/(2*J))*dt ...
         + 1/2*A*T(2)^2 + A^2/(2*J)*T(2) + A^3/(6*J^2);
elseif t > T(1)+T(2)+T(3) && t <= T(1)+T(2)+T(3)+T(4)
     dt = t - T(1) - T(2) - T(3);
     s = V*dt ...
         +  (-1/6*J*T(3)^3) + 1/2*A*T(3)^2 + (A*T(2) + A^2/(2*J))*T(3) + 1/2*A*T(2)^2 + A^2/(2*J)*T(2) + A^3/(6*J^2);
elseif t > T(1)+T(2)+T(3)+T(4) && t <= T(1)+T(2)+T(3)+T(4)+T(5)
     t_temp = Tf - t; 
     dt = t_temp - T(1) - T(2);
     s = -1/6*J*dt^3 + 1/2*A*dt^2 + (A*T(2) + A^2/(2*J))*dt ...
         + 1/2*A*T(2)^2 + A^2/(2*J)*T(2) + A^3/(6*J^2);
     s = 1 - s;
elseif t > T(1)+T(2)+T(3)+T(4)+T(5) && t <= T(1)+T(2)+T(3)+T(4)+T(5)+T(6)
     t_temp = Tf - t; 
     dt = t_temp - T(1);
     s = 1/2 * A * dt^2 + A^2/(2*J) * dt + A^3/(6*J^2);
     s = 1 - s;  
elseif t > T(1)+T(2)+T(3)+T(4)+T(5)+T(6) && t <= T(1)+T(2)+T(3)+T(4)+T(5)+T(6)+T(7) + 1e5
     t_temp = Tf - t; 
     s = 1/6 * J * t_temp^3;
     s = 1 - s;     
end
 
 end


    
    
    
