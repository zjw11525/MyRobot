ss = table2array(Untitled1);
for i=1:6
s = ss(:,i);
subplot(3,1,1);
plot(s);    
hold on;

subplot(3,1,2);
plot(diff(s));
hold on;

subplot(3,1,3);
plot(diff(diff(s)));
hold on;
end