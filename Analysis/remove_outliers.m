function [ x,y ] = remove_outliers( x,y,tolerance )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i=1:length(x)-1
    
    if y(i+1)>tolerance.*y(i)
       y(i+1)=y(i);
    end

end

