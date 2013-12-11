
%% Pathing
train.imnet.path = fullfile(getPath,'IMNET_FEATURES.mat');
train.oxford.path = fullfile(getPath,'OXFORD_FEATURES.mat');
train.oxford.phowhistpath = ...
    fullfile(getPath('oxford'),'processed','baseline-hists.mat');
train.oxford.phowclasspath = ...
    fullfile(getPath('oxford'),'processed','imageClass.mat');

test.path = fullfile(getPath,'TEST_SET_FEATURES.mat');

%% Load Data

train.imnet.load = load(train.imnet.path);
train.oxford.load = load(train.oxford.path);
train.oxford.phowhist = load(train.oxford.phowhistpath);
train.oxford.phowclass = load(train.oxford.phowclasspath);

test.load = load(test.path);

classes = {
    'cat'   % 1
    'dog'	% 2
};

%% Prep data
train.imnet.x = cell2mat(train.imnet.load.x);
train.imnet.x = pruneNanInf(train.imnet.x);
train.imnet.y = cell2mat(train.imnet.load.y);
train.oxford.x = cell2mat(train.oxford.load.x);
train.oxford.x = pruneNanInf(train.oxford.x);
train.oxford.y = cell2mat(train.oxford.load.y);

test.x_g = pruneNanInf(test.load.x_g);
test.x_m = pruneNanInf(test.load.x_m);
test.x_gm = [test.x_g test.x_m];
test.nameNum = str2double(test.load.names);

%% Create Datasets

train.imnet.ds = prtDataSetClass(train.imnet.x,train.imnet.y);
train.imnet.ds = train.imnet.ds.setClassNames(classes);
train.oxford.ds = prtDataSetClass(train.oxford.x,train.oxford.y);
train.oxford.ds = train.oxford.ds.setClassNames(classes);

test.ds_g = prtDataSetClass(test.x_g);
test.ds_gm = prtDataSetClass(test.x_gm);

%% Preprocess

zmuv = prtPreProcZmuv;
zmuv = zmuv.train(train.imnet.ds); 
train.imnet.ds_zmuv = zmuv.run(train.imnet.ds);
zmuv = zmuv.train(train.oxford.ds); 
train.oxford.ds_zmuv = zmuv.run(train.oxford.ds);

zmuv = zmuv.train(test.ds_g); 
test.ds_g_zmuv = zmuv.run(test.ds_g);
zmuv = zmuv.train(test.ds_gm); 
test.ds_gm_zmuv = zmuv.run(test.ds_gm);

%% Create and Train Classifiers

Classifier = prtClassLibSvm;
tic
train.imnet.classifier = Classifier.train(train.imnet.ds_zmuv);
train.oxford.classifier = Classifier.train(train.oxford.ds_zmuv);
toc
%% see how shitty it is
if 0
truth = train.oxford.ds_zmuv.getTargets; %the true class labels
yOutKfolds = Classifier.kfolds(train.oxford.ds_zmuv,5); %10-Fold cross-validation

[pf,pd] = prtScoreRoc(yOutKfolds);
h = plot(pf,pd);
end

%% Classify

test.imnet.classified = run(train.imnet.classifier, test.ds_g_zmuv);
test.oxford.classified = run(train.oxford.classifier, test.ds_gm_zmuv);


%%
guess1 = test.imnet.classified.data>0;
guess2 = test.oxford.classified.data>0;


q1 = sortrows([test.nameNum guess1],1);
q2 = sortrows([test.nameNum guess2],1);


qq = [1 1 1 1 0 0 0 0 0 0 0 1 0 0 0 0 1 1 0 0 1 0 1 1 0 1 1 0 0 1 1 1 1 0 0 0 0 0 1 0 1 1 1 1 0 1 0 1 1 0 0 0 0 0 0 1 1 0 1 0 0 1 0 0 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 0 0 0 1 0 1 1 1 1 0 0 0 0 0 1 1 0 1 1 0 0]';















