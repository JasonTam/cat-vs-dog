%% Organizes the oxford database
% Moves files with a capital letter to a cat folder
% Moves files with a lowercase letter to a dog folder

% This script is really ugly, but it's a one time use

annoPath = fullfile(getPath('oxford'),'annotations','xmls');
imgPath = fullfile(getPath('oxford'),'images');

mkdir(annoPath,'cat');
mkdir(annoPath,'dog');
mkdir(imgPath,'cat');
mkdir(imgPath,'dog');

annoDir = dir(fullfile(annoPath,'*.xml'));
imgDir = dir(fullfile(imgPath,'*.jpg'));

annoCell = struct2cell(annoDir);
imgCell = struct2cell(imgDir);

nameInd = strcmp(fieldnames(annoDir),'name');

fCapChar = @(str) str(1)<=Z;
% If true, first char is capital (CAT)

qA = annoCell(nameInd,:)';
qI = imgCell(nameInd,:)';

catIndAnno = cellfun(fCapChar,qA);
catIndImg = cellfun(fCapChar,qI);

%%%%%%%%%%%%%[ I GIVE UP, MOVEFILE TAKES TOO LONG]

% movefile('source','destination')