% wnid you can use to test the function
% synset dagame, lemonwood tree  n12662074
% synset Bermuda onion           n07722390
% synset football game           n00468480
% synset contact sport           n00433458
% synset domestic dogs           n02084071

homefolder = './';        %set homefolder to a path where you want to store the synset
% userName = 'username';   % a valid userName and accessKey
% accessKey = 'accesskey'; 
myCred = myImageNetAccess;
userName = myCred.userName;
accessKey = myCred.accessKey;
wnid = 'n02084071'; 
isRecursive = 1;            

downloadImages(homefolder, userName, accessKey, wnid, isRecursive)

t=wnidToDefinition(fullfile(homefolder, 'structure_released.xml'), wnid)
