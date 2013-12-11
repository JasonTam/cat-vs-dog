
%% Load (Warning, might shit on ram)

load(fullfile(getPath,'processed/testing_phow/baseline-hists.mat'))
load(fullfile(getPath,'processed/kaggle_phow/libsvmClassifier.mat'),'classifier')

%% DataSet

ds = prtDataSetClass(double(hists)');
clear hists

%% Classify with svm

tic
classified = run(classifier, ds);

toc

save(fullfile(getPath,'processed/kaggle_phow/libsvmClassified.mat'),'classified','-v7.3')

%%
load (fullfile(getPath,'processed/testing_phow/imNames.mat'))
names = cellfun(@getFName,images,'UniformOutput',false);
nameNums = str2double(names)';

thresh = mode(classified.data);

guess = classified.data > thresh;

gSort = sortrows([nameNums guess],1);

makeSubmission('./results/baseline1.csv',gSort);