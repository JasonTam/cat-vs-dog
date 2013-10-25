% Cascade Object Detector

%% Pathing
dir_dog = 'n02084071';
dir_cat = 'n02121620';

%% Adding Image Directories
imDir_dog = fullfile(getPath('imagenet'),'dog',dir_dog,'/');
imDir_cat = fullfile(getPath('imagenet'),'cat',dir_cat,'/');

addpath(imDir_dog);
addpath(imDir_cat);

% Maybe we need legit  negative pictures
% Right now, using the non stop signs 
negativeFolder = fullfile(matlabroot,'toolbox','vision','visiondemos','non_stop_signs');

%% Parse XML data
anno_dog = parse_bbox(dir_dog);
anno_cat = parse_bbox(dir_cat);

%% Form fit data
% positiveinstances needs to be in a specific form
% .imageFilename : string for image file name
% .objectBoundingBoxes : Mx4 matric of M bounding boxes

% TODO (maybe): A bit tedious, but we will manually scour the images
% Incase the image size is not consistent with the database
rowHeadings = {'imageFilename', 'objectBoundingBoxes'};
q = cell2mat(anno_dog.data);
qc = struct2cell(q);
diF = strcat(imDir_dog,qc(1,:),'.jpg');
doBB = qc(3,:);
D = [diF;doBB];
data_dog = cell2struct(D, rowHeadings, 1);

q = cell2mat(anno_cat.data);
qc = struct2cell(q);
diF = strcat(imDir_cat,qc(1,:),'.jpg');
doBB = qc(3,:);
D = [diF;doBB];
data_cat = cell2struct(D, rowHeadings, 1);


%% Train Cascade Object Detector
%% DOGE
trainCascadeObjectDetector('dogDetector.xml',...
    data_dog,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);
%% CATE
trainCascadeObjectDetector('catDetector.xml',...
    data_cat,negativeFolder,'FalseAlarmRate',0.2,'NumCascadeStages',5);











