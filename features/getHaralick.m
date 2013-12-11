function [ ret_stats ] = getHaralick( I_g )
%HARALICK Summary of this function goes here
%   Detailed explanation goes here

% [6]

glcm = graycomatrix(I_g,'NumLevels',256);
glcmn = glcm/sum(sum(glcm(:)));

stats = graycoprops(glcm,'all');

maxProb = max(glcmn(:));
sumCol = zeros(1,size(glcmn,1));
for ii = 1:size(glcmn,1);
    sumCol(ii) = sum(-glcmn(ii,1:end).*log2(glcmn(ii,1:end)+eps));
end
entropy = sum(sumCol);

ret_stats = [struct2array(stats) maxProb entropy];

end

