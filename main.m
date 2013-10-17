% -------------------------------
% Jason Tam & David Li
% MaKeene Learning
% Cats vs Dogs
% -------------------------------

%% 
data.path = './data/';
data.dir = dir(fullfile(strcat(data.path,'*.jpg')));
data.cell = struct2cell(data.dir);
data.files = strcat(data.path,data.cell(1,:))';
data.n = numel(data.files);

classes = {
    'cat'   % 1
    'dog'	% 2
};
nClasses = numel(classes);

nFeatures = 20;
% for the sake of laziness below
x = zeros(data.n,nFeatures);
y = zeros(data.n,1);

%%
for i = 1:numel(data.n)
    disp(data.files{i}(numel(data.path)+1:end));    % Display current file
    %% Set up truth
    y(i) = find(strcmp(data.files{i}(numel(data.path)+1:numel(data.path)+3),classes));
    
    track = wavread(line{1}); % Stereo track
    track_mono = sum(track,2);
    nF=1;
    
%     Get some Features
    x(i,nF:nF+160-1) = getWavedecFeature(track_mono);
    nF = nF+160;

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
%%
% Classifier = prtClassMap;
Classifier = prtClassBinaryToMaryOneVsAll;
% Classifier = prtClassMatlabTreeBagger;
% Classifier = prtClassMatlabNnet;
% Classifier = prtClassTreeBaggingCap;
Classifier.baseClassifier = prtClassAdaBoost;         
% Classifier.baseClassifier = prtClassSvm;
% Classifier.baseClassifier = prtClassLibSvm;
% Classifier.baseClassifier = prtClassRvm;


% Classifier.baseClassifier = prtClassLogisticDiscriminant;

% Classifier = Classifier.train(pca);
Classifier = Classifier.train(dataSet);
% plot(Classifier)

%%
% try computing 3 classifiers every time
% truth = dsPca.getTargets; %the true class labels
truth = dataSet.getTargets; %the true class labels
yOutKfolds = Classifier.kfolds(dataSet,5); %10-Fold cross-validation

%We need to parse the output of the KNN classifier to turn vote counts into
%class guesses - for each observation, our guess is the column with the
%most votes!
[nVotes,guess] = max(yOutKfolds.getObservations,[],2);

subplot(1,1,1); %don't plot in the last figure window.
confusion = prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
prtScoreConfusionMatrix(guess,truth,dataSet.uniqueClasses,dataSet.getClassNames);
disp('% Correct:');
sum(diag(confusion))
title('Classification Confusion Matrix');

%%

save('most_recent_workspace')




