function [ x ] = getGlobalFeatures( I, I_g )
%GETGLOBALFEATURES Summary of this function goes here
%   Detailed explanation goes here

% size returned is
% [43]

nF = 1;

%% Texture
% Haralick subset(6)
x(nF:nF+6-1) = getHaralick(I_g);
nF = nF + 6;

% Wavelets whole img(17)
nl = 6;
x(nF:nF+17-1) = getWav(I, nl);
nF = nF + 17;

% DIPUM statxture (6)
x(nF:nF+6-1) = statxture(I_g);
nF = nF + 6;


%% Other

% Circle Feats (14)
x(nF:nF+14-1) = getCircs(I);
nF = nF + 14;




end

