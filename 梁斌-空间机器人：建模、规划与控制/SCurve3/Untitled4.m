for i = 1:6
subplot(3,3,i);
plot(q(:,i),'r')
hold on;
plot(q1(:,i),'b')
hold on;
if i == 4
legend('三角函数加减速模型','三次加减速模型');
end
end