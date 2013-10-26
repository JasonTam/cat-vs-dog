% Train a Cascade Object Detector
dB = 'oxford';


%% Pathing
addpath(genpath('../'));
if strcmp(dB,'imagenet')
    dir_dog = 'n02084071';
    dir_cat = 'n02121620';
end
if strcmp(dB,'oxford')
    dir_dog = 'dogFace';
    dir_cat = 'catFace';
end

%% Adding Image Directories

% Using ImageNet (general bbox)
if strcmp(dB,'imagenet')
    imDir_dog = fullfile(getPath('imagenet'),'dog',dir_dog,'/');
    imDir_cat = fullfile(getPath('imagenet'),'cat',dir_cat,'/');
end
% Using Oxford (face bbox)
if strcmp(dB,'oxford')
    imDir_dog = fullfile(getPath('oxford'),'images','dog','/');
    imDir_cat = fullfile(getPath('oxford'),'images','cat','/');
end

addpath(imDir_dog);
addpath(imDir_cat);

% Maybe we need legit  negative pictures
% Right now, using the non stop signs 
negativeFolder = fullfile(matlabroot,'toolbox','vision','visiondemos','non_stop_signs');

%% Parse XML data
% Using ImageNet (general bbox)
if strcmp(dB,'imagenet')
    annoPath_dog = strcat(getPath('imagenet'),'Annotation/',dir_dog,'/');
    annoPath_cat = strcat(getPath('imagenet'),'Annotation/',dir_cat,'/');
end
% Using Oxford (face bbox)
if strcmp(dB,'oxford')
    annoPath_dog = fullfile(getPath('oxford'),'annotations','xmls','dog','/');
    annoPath_cat = fullfile(getPath('oxford'),'annotations','xmls','cat','/');
end


anno_dog = parse_bbox(annoPath_dog);
anno_cat = parse_bbox(annoPath_cat);

%% Form fit data
% positiveinstances needs to be in a specific form
% .imageFilename : string for image file name
% .objectBoundingBoxes : Mx4 matric of M bounding boxes
% bounding boxes are i nthe form: [x y width height]

% TODO (maybe): A bit tedious, but we will manually scour the images
% Incase the image size is not consistent with the database
rowHeadings = {'imageFilename', 'objectBoundingBoxes'};

q = cell2mat(anno_dog.data);
ind_name = strcmp(fieldnames(q),'name');    % index of the name field
ind_bbox = strcmp(fieldnames(q),'bbox');    % index of the bbox field

qc = struct2cell(q);
% diF = strcat(imDir_dog,qc(ind_name,:),'.JPEG');
diF = strcat(imDir_dog,qc(ind_name,:),'');
doBB = qc(ind_bbox,:);
D = [diF;doBB];
data_dog = cell2struct(D, rowHeadings, 1);

q = cell2mat(anno_cat.data);
qc = struct2cell(q);
% diF = strcat(imDir_cat,qc(ind_name,:),'.JPEG');
diF = strcat(imDir_cat,qc(ind_name,:),'');
doBB = qc(ind_bbox,:);
D = [diF;doBB];
data_cat = cell2struct(D, rowHeadings, 1);


%% Train Cascade Object Detector
%% DOGE

trainCascadeObjectDetector(strcat(dir_dog,'.xml'),...
    data_dog,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
%% CATE
trainCascadeObjectDetector(strcat(dir_cat,'.xml'),...
    data_cat,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);











