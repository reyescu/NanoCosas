function y = gass1f(x,datfit)
off=datfit(1);
A=datfit(2);
B=datfit(3);
C=datfit(4);
y = off+A.*1./(B.*sqrt(2.*pi)).*exp(-(x-C).^2/(2.*B));
end
