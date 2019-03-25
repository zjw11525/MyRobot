% 功能：向各关节规划器中添加期望运动点
% 输入: i——————规划关节序号
%       point——关节期望运动点
% 输出：out————规划器添加点成功标志
function out = cubicAddPoint( i,point )

    global cubic
	%判断是否需要加入新点
    if cubic(i).needNextPoint == 0 
        out = -1 ;
        return
    end
	
	% 如果规划器没有满则补满规划器
    if cubic(i).filled == 0	
        cubic(i).x0 = point;
        cubic(i).x1 = point;
        cubic(i).x2 = point;
        cubic(i).x3 = point;
        cubic(i).filled = 1;
	% 如果规划器已满则替换最后一点
    else
        cubic(i).x0 = cubic(i).x1;
        cubic(i).x1 = cubic(i).x2;
        cubic(i).x2 = cubic(i).x3;
        cubic(i).x3 = point;
    end
    
	% 计算两个拟合点的位置
    wp0 = (cubic(i).x0 + 4*cubic(i).x1 + cubic(i).x2)/6.0;
    wp1 = (cubic(i).x1 + 4*cubic(i).x2 + cubic(i).x3)/6.0;
	% 计算两个拟合点的速度
    vel0 = (cubic(i).x2 - cubic(i).x0)/(2.0*cubic(i).sTime);
    vel1 = (cubic(i).x3 - cubic(i).x1)/(2.0*cubic(i).sTime);
	% 计算规划器参数
    cubic(i).d = wp0;
	cubic(i).c = vel0;
	cubic(i).b = 3*(wp1 - wp0)/cubic(i).sTime^2 - (2*vel0 + vel1)/cubic(i).sTime;
	cubic(i).a = -2*(wp1 - wp0)/cubic(i).sTime^3 + (vel0 + vel1)/cubic(i).sTime^2;
	
	%更新状态
    cubic(i).Tnow = 0;
    cubic(i).needNextPoint = 0;
	out = 0;
end

