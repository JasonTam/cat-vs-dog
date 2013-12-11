function [ x ] = pruneNanInf( x )
%PRUNENANINF Summary of this function goes here
%   Detailed explanation goes here

x(isnan(x)|isinf(x)) = 0;

end

