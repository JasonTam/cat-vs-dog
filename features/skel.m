function [ output_args ] = skel( BW )
%SKEL Summary of this function goes here
%   Detailed explanation goes here

tic
BW3 = bwmorph(BW,'skel',Inf);
toc

end

