
%% Load

load(fullfile(getPath,'processed/kaggle_phow/baseline-hists.mat'))
load(fullfile(getPath,'processed/kaggle_phow/imageClass.mat'))

%% Make Dataset

classes = {
    'cat'   % 1
    'dog'	% 2
};

ds = prtDataSetClass(double(hists)',imageClass');
ds = ds.setClassNames(classes);
clear hists
%% Preproc

zmuv = prtPreProcZmuv;
zmuv = zmuv.train(ds); 
ds_zmuv = zmuv.run(ds);

%% Train svm

libsvm = prtClassLibSvm;
tic
classifier = libsvm.train(ds_zmuv);
toc

save(fullfile(getPath,'processed/kaggle_phow/libsvmClassifier.mat'),'classifier','-v7.3')