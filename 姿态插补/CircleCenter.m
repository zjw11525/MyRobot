function [center,rad] = CircleCenter(p1, p2, p3)
% 根据三个空间点，计算出其圆心及半径
% rad>0:   圆弧
% rad = -1:输入数据有问题
% rad = -2:三点共线

center = 0;rad =0;
% 数据检查
% 检查数据输入格式是否正确
if size(p1,2)~=3 || size(p2,2)~=3 || size(p3,2)~=3
    fprintf('输入点维度不一致\n');rad = -1;return;
end
n = size(p1,1);
if size(p2,1)~=n || size(p3,1)~=n
    fprintf('输入点维度不一致\n');rad = -1;return;
end

% 计算p1到p2的单位向量和p1到p3的单位向量
% 检查点是否相同
v1 = p2 - p1;
v2 = p3 - p1;
if find(norm(v1)==0) | find(norm(v2)==0) %#ok<OR2>
    fprintf('输入点不能一样\n');rad = -1;return;
end
v1n = v1/norm(v1);
v2n = v2/norm(v2);

% 计算圆平面上的单位法向量
% 检查三点是否共线
nv = cross(v1n,v2n);
 if all(nv==0)
    fprintf('三个点共线\n');rad = -2;return;
 end
if find(sum(abs(nv),2)<1e-5)
    fprintf('三点过于趋近直线\n');rad = -1;return;
end

% 计算新坐标系UVW轴
u = v1n;
w = cross(v2,v1)/norm(cross(v2,v1));
v = cross(w,u);

% 计算投影
bx = dot(v1,u);
cx = dot(v2,u);
cy = dot(v2,v);

% 计算圆心
h = ((cx - bx/2)^2 + cy^2 -(bx/2)^2)/(2*cy);
center = zeros(1,3);
center(1,:) = p1(1,:) + bx/2.*u(1,:) + h.*v(1,:);

% 半径
rad = sqrt((center(1,1)-p1(1,1)).^2+(center(1,2)-p1(1,2)).^2+(center(1,3)-p1(1,3)).^2);
end
