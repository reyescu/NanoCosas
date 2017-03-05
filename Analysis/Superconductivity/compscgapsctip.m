clear all
close all


E=-0.003:0.000005:0.003;
T=5;
delta=0.0005;
gamma=0.000005;


[didv,curr]=SCgap(E,T,delta,gamma,1);
figure(1)
scatter(E,curr)
hold on
figure(2)
scatter(E(1:end-1),didv)
hold on
[didv,curr]=SCgapSCtip(E,T,delta,gamma,1);
figure(1)
scatter(E,curr)
figure(2)
scatter(E(1:end-1),didv)