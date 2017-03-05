function P=FermiDirac(E,T)

%E in eV
%T in Kelvin

kb=8.617343*10^(-5);

P=1./(1+exp(E./(kb.*T)));