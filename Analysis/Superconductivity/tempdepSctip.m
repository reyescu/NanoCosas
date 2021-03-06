close all
clear all



E=-0.003:0.000005:0.003;
%T=1;
E=-0.004:0.000005:0.004;
%T=1;
delta=0.00135;
gamma=0.000025;


for T=4:8
    clear curr didv
   [didv,curr]=SCgapSCtip(E,T,delta,gamma,1);
   figure(1)
   hold on
scatter(E./1E-3,curr)
figure(2)
hold on
scatter(E(1:end-1)./1E-3,diff(curr))
leg{T-3}=['T=',num2str(T)'];
end

figure(2)
set(gca,'FontSize',18)
xlabel('Energy (meV)','FontSize',20)
ylabel('dI/dV (a.u.)','FontSize',20)

legend(leg)

figure(1)
set(gca,'FontSize',18)
xlabel('Energy (meV)','FontSize',20)
ylabel('Current','FontSize',20)

legend(leg)
