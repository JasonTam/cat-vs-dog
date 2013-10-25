% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

addpath(genpath('./toolbox_ext'));
%% 
anno.path = strcat(getPath('imagenet'),'Annotation/n02084071/');

anno.dir = dir(fullfile(strcat(anno.path,'*.xml')));
anno.cell = struct2cell(anno.dir);
anno.files = strcat(anno.path,anno.cell(1,:))';
anno.n = numel(anno.files);

anno.data = cell(anno.n,1);

scalebbox = @(bbox,imgsize) bbox./...
    [imgsize(2) imgsize(1) imgsize(2) imgsize(1)];
%% Go through each xml file to get bounding box info
for i = 1:anno.n
    qq = VOCreadrecxml(anno.files{i});
    anno.data{i}.name = qq.filename;
    anno.data{i}.imgsize = qq.imgsize;

    % Accounting for multiple bboxes
    ind_obj = strcmp(fieldnames(qq.objects),'bbox');
    q_obj = struct2cell(qq.objects);
    % [xmin ymin xmax ymax] each row of these is a seperate bbox
    anno.data{i}.bbox = shiftdim(cell2mat(q_obj(ind_obj,1,:)),1)';
    % Scale bbox to imgsize (incase sizes don't match with actual image)
    anno.data{i}.bbox_norm = anno.data{i}.bbox./...
        repmat(fliplr(anno.data{i}.imgsize(1:2)),[size(anno.data{i}.bbox,1) 2]);
    
    
end



