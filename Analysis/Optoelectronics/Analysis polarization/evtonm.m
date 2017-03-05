function [lambda]=evtonm(energy)

hh=4.135667516E-15;
cc=299792458;

lambda=hh*cc./energy.*1E9;