function [ ret ] = getCircs( I )
%GETCIRCS Summary of this function goes here
%   Detailed explanation goes here

% [14]

% % Get the 2 best circles
n_c = 2;
s = 0.9;
[c, r] = imfindcircles(I,...
    [6 50],...
    'ObjectPolarity','bright',...
    'Sensitivity',s);

ret = zeros(14,1);
if size(c,1)<2
    ret = zeros(14,1);
else
    % Get 2 best circles
    c = c(1:n_c,:);
    r = r(1:n_c,:);

    % Distance between centers
    d = pdist(c,'euclidean');
    % Normalize by radius
    d = d/mean(r);
    
    % Difference in radii
    dr = diff(r);

    % Avg colors
thetaResolution = 10; 
theta=(0:thetaResolution:360)'*pi/180;
    x = bsxfun(@times,r',cos(theta));
    x = bsxfun(@plus,x,(c(:,1))');

    y = bsxfun(@times,r',sin(theta));
    y = bsxfun(@plus,y,(c(:,2))');

    cmask = zeros([size(I,1) size(I,2) 2]);
    cmask(:,:,1) = poly2mask(x(:,1),y(:,1),size(I,1),size(I,2));
    cmask(:,:,2) = poly2mask(x(:,2),y(:,2),size(I,1),size(I,2));

    I_col = reshape(I,[size(I,1)*size(I,2) 3]);
    circ1 = I_col(logical(cmask(:,:,1)),:);
    circ2 = I_col(logical(cmask(:,:,2)),:);

    colorFeats = [mean(circ1) mean(circ2),...
        std(double(circ1)) std(double(circ1))];

    ret = [d dr colorFeats];
end

end

