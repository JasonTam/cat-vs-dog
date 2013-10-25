% Apply the Cascade Object Detectors

addpath(genpath('../'));
dir_dog = 'n02084071';
dir_cat = 'n02121620';

dogDetector = vision.CascadeObjectDetector(strcat(dir_dog,'.xml'));
catDetector = vision.CascadeObjectDetector(strcat(dir_cat,'.xml'));

