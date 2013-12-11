function [ name ] = getFName( str )
%GETFNAME Summary of this function goes here
%   Detailed explanation goes here

[~,name,~] = fileparts(str);

end

