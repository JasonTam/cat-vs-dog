function [ ret ] = getFourierDesc( C, nd )
%FOURIERDESC Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    nd = 64;
end

if size(C,1)<nd
    C = padarray(C,nd-size(C,1),'post');
end

% Uses Gonzalez 
F = frdescp(C);
np = numel(F);
ret_F = F((np-nd)/2+1:(np+nd)/2);

ret = [log(abs(ret_F)); phase(ret_F)];
% no funny business allowed
% log

end

