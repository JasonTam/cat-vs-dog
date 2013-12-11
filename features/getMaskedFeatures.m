function [ x ] = getMaskedFeatures( I_m, I_g, BW, C )
%GETMASKEDFEATURES Summary of this function goes here
%   Detailed explanation goes here

% I_m: masked image
% I_g: gray level masked image
% BW: Mask
% C: Contour of mask

% [186]

nF = 1;

%% Texture
% Haralick subset(6)
x(nF:nF+6-1) = getHaralick(I_g);
nF = nF + 6;

% Wavelets masked img(17)
nl = 6;
x(nF:nF+17-1) = getWav(I_m, nl);
nF = nF + 17;

% DIPUM statxture (6)
x(nF:nF+6-1) = statxture(I_g);
nF = nF + 6;

%% Shape

% Fourier Descriptors (128)
nd = 64;
x(nF:nF+2*nd-1) = getFourierDesc(C,nd);
nF = nF + 128;
% Zernike Moments (9)
x(nF:nF+9-1) = getZernikeMoments(BW);
nF = nF + 9;

% Region Properties (6)
x(nF:nF+6-1) = getRegionProps(BW);
nF = nF + 6;

%% Other

% Circle Feats (14)
x(nF:nF+14-1) = getCircs(I_m);
nF = nF + 14;




end

