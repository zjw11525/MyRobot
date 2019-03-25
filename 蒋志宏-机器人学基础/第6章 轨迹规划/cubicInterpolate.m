% 功能：计算下一个规划点的值
% 输入: i——————规划关节序号
% 输出：out————下一步的规划角度
function out = cubicInterpolate( i )
    global cubic
	% 如果上次规划已完成则添加新点
    if cubic(i).needNextPoint
       cubicAddPoint(i,cubic(i).x3); 
    end
	
	% 计算规划器时间
    cubic(i).Tnow = cubic(i).Tnow + cubic(i).Inc;
    
	% 判断此次规划是否结束
    if abs(cubic(i).sTime - cubic(i).Tnow)<0.5*cubic(i).Inc
        cubic(i).needNextPoint = 1;
    end
	
    % 计算下一步规划值
    out = cubic(i).a*cubic(i).Tnow^3 + cubic(i).b*cubic(i).Tnow^2 + cubic(i).c*cubic(i).Tnow + cubic(i).d;
end

