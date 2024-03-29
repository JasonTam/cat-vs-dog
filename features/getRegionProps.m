function [ ret ] = getRegionProps( BW )
%GETREGIONPROPS Summary of this function goes here
%   Detailed explanation goes here

% [6]

ret = struct2array(...
    regionprops(BW,...
    'Eccentricity',...
    'ConvexArea',...
    'EquivDiameter',...
    'Solidity',...
    'Extent',...
    'Perimeter')...
    );
% ONly take 1 region

if numel(ret)>6
    ret = ret(1:6);
elseif numel(ret)~=6
    ret = zeros(1,6);
end

end

