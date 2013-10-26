% Apply the Cascade Object Detectors

addpath(genpath('../'));
dir_dog = 'n02084071';
dir_cat = 'n02121620';

dogDetector = vision.CascadeObjectDetector(...
    'ClassificationModel',strcat(dir_dog,'.xml'),...
    'MergeThreshold',50);


catDetector = vision.CascadeObjectDetector(strcat(dir_cat,'.xml'));
	
catFaceDetector = vision.CascadeObjectDetector;
catFaceDetector.ClassificationModel = 'catFace.xml';
catFaceDetector.MergeThreshold = 300;
catFaceDetector.ScaleFactor = 1.05;

dogFaceDetector = vision.CascadeObjectDetector;
dogFaceDetector.ClassificationModel = 'dogFace.xml';
dogFaceDetector.MergeThreshold = 300;
catFaceDetector.ScaleFactor = 1.05;

I = imread('../data/cat.0.jpg');

bboxes = step(catFaceDetector, I);

IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'FACE');   
figure, imshow(IFaces), title('Detected object');  
 
