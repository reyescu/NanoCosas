function [energy]=nmtoev(lambda)

hh=4.135667516E-15;
cc=299792458;

energy=hh*cc./(lambda.*1E-9);