function N=SCDOS(E,delta,gamma)

%E in eV
%delta in eV
%gamma undefined

N=abs(real((E-1i*gamma)./sqrt((E-1i*gamma).^2-delta^2)));