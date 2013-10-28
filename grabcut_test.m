% Example on using the GrabCut toolbox

addpath(genpath('./toolbox_ext/GrabCut'));

im = imread('./data/dog.2.jpg');

% roipoly will run MATLAB's built in gui tool to many a polygon ROI
% left click vertices, right click to complete poly
% double click inside to finish
fixedBG = ~roipoly(im);

% Params
Beta = 0.3;
k = 4;
G = 50;
maxIter = 10;
diffThreshold = 0.001;

imBounds = im;
bounds = double(abs(edge(fixedBG)));
se = strel('square',3);
bounds = 1 - imdilate(bounds,se);
imBounds(:,:,2) = imBounds(:,:,2).*uint8(bounds);
imBounds(:,:,3) = imBounds(:,:,3).*uint8(bounds);

% PrevRes = CurrRes;
imd = double(im);

L = GCAlgo(imd, fixedBG,k,G,maxIter, Beta, diffThreshold, []);
L = double(1 - L);

CurrRes = imd.*repmat(L , [1 1 3]);     % Apply Mask

figure
subplot(1,2,1)
imshow(im);
subplot(1,2,2)
imshow(uint8(CurrRes));



