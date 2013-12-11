function [ ret ] = getZernikeMoments( BW )
%GETZERNIKEMOMENTS Summary of this function goes here
%   Detailed explanation goes here

[ymax,~] = max(size(BW));

BW_sq = zeros(ymax+mod(ymax,2));
BW_sq(1:size(BW,1),1:size(BW,2)) = BW;

ret = zeros(9,1);
% [~, AOH, PhiOH] = Zernikmoment(BW,1,-1);

[~, ret(1), ~] = Zernikmoment(BW_sq,1,-1);
[~, ret(2), ~] = Zernikmoment(BW_sq,1,1);

[~, ret(3), ~] = Zernikmoment(BW_sq,2,-2);
[~, ret(4), ~] = Zernikmoment(BW_sq,2,0);
[~, ret(5), ~] = Zernikmoment(BW_sq,2,2);

[~, ret(6), ~] = Zernikmoment(BW_sq,3,-3);
[~, ret(7), ~] = Zernikmoment(BW_sq,3,-1);
[~, ret(8), ~] = Zernikmoment(BW_sq,3,1);
[~, ret(9), ~] = Zernikmoment(BW_sq,3,3);

end

