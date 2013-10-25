% Apply the Cascade Object Detectors

addpath(genpath('../'));
dir_dog = 'n02084071';
dir_cat = 'n02121620';

dogDetector = vision.CascadeObjectDetector(...
    'ClassificationModel',strcat(dir_dog,'.xml'),...
    'MergeThreshold',50);


catDetector = vision.CascadeObjectDetector(strcat(dir_cat,'.xml'));
	
eyeDetector = vision.CascadeObjectDetector(...
    'ClassificationModel','EyePairBig');


I = imread('../data/cat.1.jpg');

bboxes = step(catDetector, I);

IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'DOGE');   
figure, imshow(IFaces), title('Detected dog');  

[centers, radii, metric] = imfindcircles(I,[8 100]);


viscircles(centers, radii,'EdgeColor','b');