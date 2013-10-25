% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------
function [ anno ] = parse_bbox( whichPath )
%PARSE_BBOX Returns annotation structures
%   'whichPath' : the directory (WNID) of annotation xml files to extract

if nargin<1; whichPath = 'n02084071'; end;

addpath(genpath('./toolbox_ext'));
%% 
anno.path = strcat(getPath('imagenet'),'Annotation/',whichPath,'/');

anno.dir = dir(fullfile(strcat(anno.path,'*.xml')));
anno.cell = struct2cell(anno.dir);
anno.files = strcat(anno.path,anno.cell(1,:))';
anno.n = numel(anno.files);

anno.data = cell(anno.n,1);

%% Go through each xml file to get bounding box info
h = waitbar(0,strcat('Extracting Data from:/', whichPath));
for i = 1:anno.n
    qq = VOCreadrecxml(anno.files{i});
    anno.data{i}.name = qq.filename;
    anno.data{i}.imgsize = qq.imgsize;

    % Accounting for multiple bboxes
    ind_obj = strcmp(fieldnames(qq.objects),'bbox');
    q_obj = struct2cell(qq.objects);
    % [xmin ymin xmax ymax] each row of these is a seperate bbox
    anno.data{i}.bbox2 = shiftdim(cell2mat(q_obj(ind_obj,1,:)),1)';
    
    % Need to convert to [x y width height]
    anno.data{i}.bbox = ...
        [anno.data{i}.bbox2(:,1:2) anno.data{i}.bbox2(:,3:4)-anno.data{i}.bbox2(:,1:2)];
    
    % Scale bbox to imgsize (incase sizes don't match with actual image)
    anno.data{i}.bbox_norm = anno.data{i}.bbox./...
        repmat(fliplr(anno.data{i}.imgsize(1:2)),[size(anno.data{i}.bbox,1) 2]);
    
    waitbar(i / anno.n);
end
close(h)

end

