%% Load training

load(fullfile(getPath,'processed/kaggle_phow/baseline-hists.mat'))
load(fullfile(getPath,'processed/kaggle_phow/imageClass.mat'))

%% Datasets

train_x = double(hists');
train_x = [train_x(1:end/2-29,:); train_x(end/2:end-28,:)];
imageClass = [imageClass(:,1:end/2-29) imageClass(:,end/2:end-28)];
clear hists

train_x = bsxfun(@times,train_x,1./max(train_x,[],2));


% Convert Targets to Logical Array
t = zeros(numel(imageClass), numel(unique(imageClass)));
inds = sub2ind(size(t), (1:numel(imageClass))', imageClass');
t(inds) = 1;
train_y = double(t);

% test_y  = double(test_y);

%%  ex2 train a 100-100-2 DBN and use its weights to initialize a NN
dbn.sizes = [100 100 100 100];
opts.numepochs =   20;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   .1;
dbn = dbnsetup(dbn, train_x, opts);
dbn = dbntrain(dbn, train_x, opts);

nn = dbnunfoldtonn(dbn, 2);
nn.activation_function = 'sigm';

nn.alpha  = .5;
nn.lambda = 1e-4;
opts.numepochs =  100;
opts.batchsize = 100;

nn = nntrain(nn, train_x, train_y, opts);
save(fullfile(getPath,'processed/kaggle_phow/DBN.mat'),'nn','-v7.3')

%%
load(fullfile(getPath,'processed/testing_phow/baseline-hists.mat'))
test_x  = double(hists)';

test_x = bsxfun(@times,test_x,1./max(test_x,[],2));

clearvars -except test_x nn imageClass

addpath('./functs');
[outnet, g] = myNNTEST(nn, test_x);

save('./results/DBN.mat','g')

%%

test.path = fullfile(getPath,'TEST_SET_FEATURES.mat');
test.load = load(test.path);
test.nameNum = str2double(test.load.names);

guess = g>1;

q = sortrows([test.nameNum guess],1);






