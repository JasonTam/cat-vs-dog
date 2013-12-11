% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

%% 

data.source = 'oxford';
switch data.source
    case 'data'
        data.path = strcat(getPath,'train/');     % Train path for origset 
    case 'imagenet'
    case 'oxford'
        data.path = fullfile(getPath(data.source),'images');
        data.annoPath = fullfile(getPath(data.source),'annotations');
        data.triPath = fullfile(data.annoPath,'trimaps');
end


data.dir = dir(fullfile(strcat(data.path,'*.jpg')));
data.cell = struct2cell(data.dir);
data.files = strcat(data.path,data.cell(1,:))';
data.n = numel(data.files);

classes = {
    'cat'   % 1
    'dog'	% 2
};
nClasses = numel(classes);

nFeatures = 2;
% for the sake of laziness below
x = zeros(data.n,nFeatures);
y = zeros(data.n,1);

%%
for i = 1:data.n
    disp(data.files{i}(numel(data.path)+1:end));    % Display current file
    % Set up truth
    y(i) = find(strcmp(data.files{i}(numel(data.path)+1:numel(data.path)+3),classes));
    
    % Read Image
    I = imread(data.files{i});
    
    % Extract Features
    nF = 1;
%     Dummy features for now
    x(i,nF:nF+2-1) = [size(I,1) size(I,2)];


end

%%
dataSet = prtDataSetClass(x,y);
dataSet = dataSet.setClassNames(classes);
% plot(dataSet);

%%
% % % 
if 0
    pca = prtPreProcPca;      % Create a prtPreProcPca object
    pca.nComponents = 3;      % nComponents is a field of prtPreProcPca objects
    pca = pca.train(dataSet); % Outputs a pca object with pcaVectors set
    pca = pca.run(dataSet); 
    % 
    % plot the data.
    % figure(1); plot(dataSet);
    % figure(2); plot(pca);
end
%% Run Classifier
% Classifier = prtClassMap;
Classifier = prtClassBinaryToMaryOneVsAll;
% Classifier = prtClassMatlabTreeBagger;
% Classifier = prtClassMatlabNnet;
% Classifier = prtClassTreeBaggingCap;
% Classifier.baseClassifier = prtClassAdaBoost;         
% Classifier.baseClassifier = prtClassSvm;
Classifier.baseClassifier = prtClassLibSvm;
% Classifier.baseClassifier = prtClassRvm;

% Classifier.baseClassifier = prtClassLogisticDiscriminant;

% Classifier = Classifier.train(pca);
Classifier = Classifier.train(dataSet);
% plot(Classifier)

%% Validation
% try computing 3 classifiers every time
% truth = dsPca.getTargets; %the true class labels
truth = dataSet.getTargets; %the true class labels
yOutKfolds = Classifier.kfolds(dataSet,5); %10-Fold cross-validation

%We need to parse the output of the KNN classifier to turn vote counts into
%class guesses - for each observation, our guess is the column with the
%most votes!
[nVotes,guess] = max(yOutKfolds.getObservations,[],2);


%% Plot
subplot(1,1,1); %don't plot in the last figure window.
confusion = prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
title('Classification Confusion Matrix');

fprintf('Perc Correct: %d\n', sum(diag(confusion)));

%%

save('most_recent_workspace')




