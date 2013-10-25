% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

%% 
anno.path = './n02084071/';

anno.dir = dir(fullfile(strcat(anno.path,'*.xml')));
anno.cell = struct2cell(anno.dir);
anno.files = strcat(anno.path,anno.cell(1,:))';
anno.n = numel(anno.files);

anno.data = cell(anno.n,1);
%% Go through each xml file to get bounding box info
for i = 1:anno.n
    qq = VOCreadrecxml(anno.files{i});
    anno.data{i}.name = qq.filename;
    anno.data{i}.imgsize = qq.imgsize;
    % Note that there might be more than 1 bbox
    % may have to take care of that later
    anno.data{i}.bbox = qq.objects.bbox;
    % [xmin ymin xmax ymax]
    anno.data{i}.bbox_norm = qq.objects.bbox./...
        [qq.imgsize(2) qq.imgsize(1) qq.imgsize(2) qq.imgsize(1)];
end



