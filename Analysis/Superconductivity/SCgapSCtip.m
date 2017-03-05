function [didv,curr]=SCgapSCtip(E,T,delta,gamma,Go)

%E in eV
%T in Kelvin
%E in eV
%delta in eV
%gamma undefined


kb=8.617343*10^(-5);
arr = zeros(size(E));
A = -E(length(E))*10:E(length(E))/750:E(length(E))*10;


for i=1:length(E)
    arr(i) = trapz(A, (FermiDirac(-E(i)+A, T) - FermiDirac(A,T)) .* SCDOS(-E(i)+A, delta, gamma).* SCDOS(A, delta, gamma));
end
curr=Go.*arr;
didv=diff(curr);
